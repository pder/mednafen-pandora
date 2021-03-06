void Utility::updateFullscreenState() {
  video.clear();

  if(config().video.isFullscreen == false) {
    config().video.context = &config().video.windowed;
    mainWindow->showNormal();
    mainWindow->menuBar->setVisible(true);
    mainWindow->statusBar->setVisible(true);
  } else {
    config().video.context = &config().video.fullscreen;
    mainWindow->showFullScreen();
    mainWindow->menuBar->setVisible(false);
    mainWindow->statusBar->setVisible(false);
  }

  QApplication::processEvents();
  #if defined(PLATFORM_X)
  //Xlib requires time to propogate fullscreen state change message to window manager;
  //if window is resized before this occurs, canvas may not resize correctly
  usleep(50000);
  #endif

  //refresh options that are unique to each video context
  updateVideoMode();
  updateHardwareFilter();
  updateSoftwareFilter();
  mainWindow->syncUi();
}

//if max exceeds x: x is set to max, and y is scaled down to keep proportion to x
void Utility::constrainSize(unsigned &x, unsigned &y, unsigned max) {
  if(x > max) {
    double scalar = (double)max / (double)x;
    y = (unsigned)((double)y * (double)scalar);
    x = max;
  }
}

void Utility::resizeMainWindow() {
  unsigned region = config().video.context->region;
  unsigned multiplier = config().video.context->multiplier;
  unsigned width = 256 * multiplier;
  unsigned height = (region == 0 ? 224 : 239) * multiplier;

  if(config().video.context->correctAspectRatio) {
    if(region == 0) {
      width = (double)width * config().video.ntscAspectRatio + 0.5;  //NTSC adjust
    } else {
      width = (double)width * config().video.palAspectRatio  + 0.5;  //PAL adjust
    }
  }

  if(config().video.isFullscreen == false) {
    //get effective desktop work area region (ignore Windows taskbar, OS X dock, etc.)
    QRect deskRect = QApplication::desktop()->availableGeometry(mainWindow);

    //ensure window size will not be larger than viewable desktop area
    constrainSize(height, width, deskRect.height()); //- frameHeight);
    constrainSize(width, height, deskRect.width());  //- frameWidth );

    mainWindow->canvas->setFixedSize(width, height);
    mainWindow->show();
  } else {
    for(unsigned i = 0; i < 2; i++) {
      unsigned iWidth = width, iHeight = height;

      constrainSize(iHeight, iWidth, mainWindow->canvasContainer->size().height());
      constrainSize(iWidth, iHeight, mainWindow->canvasContainer->size().width());

      //center canvas onscreen; ensure it is not larger than viewable area
      mainWindow->canvas->setSizePolicy(QSizePolicy::Expanding, QSizePolicy::Expanding);
      mainWindow->canvas->setFixedSize(iWidth, iHeight);
      mainWindow->canvas->setMinimumSize(0, 0);

      usleep(2000);
      QApplication::processEvents();
    }
  }

  //workaround for Qt/Xlib bug:
  //if window resize occurs with cursor over it, Qt shows Qt::Size*DiagCursor;
  //so force it to show Qt::ArrowCursor, as expected
  mainWindow->setCursor(Qt::ArrowCursor);
  mainWindow->canvasContainer->setCursor(Qt::ArrowCursor);
  mainWindow->canvas->setCursor(Qt::ArrowCursor);

  //workaround for DirectSound(?) bug:
  //window resizing sometimes breaks audio sync, this call re-initializes it
  updateAvSync();
}

void Utility::toggleSynchronizeVideo() {
  mainWindow->settings_emulationSpeed_syncVideo->toggleChecked();
  config().video.synchronize = mainWindow->settings_emulationSpeed_syncVideo->isChecked();
  updateAvSync();
}

void Utility::toggleSynchronizeAudio() {
  mainWindow->settings_emulationSpeed_syncAudio->toggleChecked();
  config().audio.synchronize = mainWindow->settings_emulationSpeed_syncAudio->isChecked();
  updateAvSync();
}

void Utility::setNtscMode() {
  config().video.context->region = 0;
  updateVideoMode();
  resizeMainWindow();
  mainWindow->shrink();
  mainWindow->syncUi();
}

void Utility::setPalMode() {
  config().video.context->region = 1;
  updateVideoMode();
  resizeMainWindow();
  mainWindow->shrink();
  mainWindow->syncUi();
}

void Utility::toggleSmoothVideoOutput() {
  mainWindow->settings_smoothVideo->toggleChecked();
  config().video.context->hwFilter = mainWindow->settings_smoothVideo->isChecked();
  updateHardwareFilter();
  mainWindow->syncUi();
}

void Utility::toggleAspectCorrection() {
  mainWindow->settings_videoMode_correctAspectRatio->toggleChecked();
  config().video.context->correctAspectRatio = mainWindow->settings_videoMode_correctAspectRatio->isChecked();
  resizeMainWindow();
  mainWindow->shrink();
}

void Utility::setScale(unsigned scale) {
  config().video.context->multiplier = scale;
  resizeMainWindow();
  mainWindow->shrink();
  mainWindow->syncUi();
}

void Utility::toggleFullscreen() {
  config().video.isFullscreen = !config().video.isFullscreen;
  updateFullscreenState();
  resizeMainWindow();
  mainWindow->syncUi();
}

void Utility::toggleMenubar() {
  mainWindow->menuBar->setVisible(!mainWindow->menuBar->isVisibleTo(mainWindow));
  resizeMainWindow();
  mainWindow->shrink();
}

void Utility::toggleStatusbar() {
  mainWindow->statusBar->setVisible(!mainWindow->statusBar->isVisibleTo(mainWindow));
  resizeMainWindow();
  mainWindow->shrink();
}
