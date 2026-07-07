/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { LogDomain, LogHelper, Trace } from '@ohos/basicutils';
import { BaseViewController } from '@ohos/frameworkcommon';
import { DeviceHelper, ViewManagerPolicy, ViewType, WallpaperManager, WallpaperData } from '@ohos/frameworkwrapper';
import { SCBPropertyChangeReason, SCBScreenProperty, SCBSystemSceneSession } from '@ohos/windowscene';
import { NotificationSettingBtn } from '@ohos/notificationcomponent/src/main/ets/pages/common/NotificationSettingBtn';
import { ScreenLockBlurButtonVM, screenLockBlurButtonVM } from '@ohos/notificationcomponent/src/main/ets/vm/ScreenLockBlurButtonVM';
import { NotificationType } from '@ohos/notificationcomponent/src/main/ets/common/NotificationType';
import { SlStateBaseMgr } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { DisplayStateManager, DisplayStateListener } from '@ohos/screenlockcommon/Index';
import Constants from '@ohos/screenlockcomponent/src/main/ets/common/Constants';
import { defaultManifestParam, LockManifest } from '@ohos/screenlockwidget/src/main/ets/common/theme/ThemeHelperUtil';
import { BouncerView } from './component/BouncerView';
import { MainPageView } from './component/MainPageView';
import { RootVc } from './controller/RootVc';
import { COMPONENT_ID_SCREEN_LOCK_ROOT, SCBScreenLockVm } from './viewmodel/SCBScreenLockVm';
import { clockLayoutHelper } from '@ohos/screenlockwidget/src/main/ets/clock/common/ClockLayoutHelper';
import { slComStateMgr } from './model/manager/SlCommonStateManager';
import lazy { ImmersiveNtfSettingDialogView } from '@ohos/immersivekeyguard';
import { slWallpaperMgr } from '@ohos/screenlockcommon/src/main/ets/wallpaper/ScreenLockWallpaperManager';
import { slStateHelper } from './model/helper/SlStateHelper';
import { SlBindState } from './model/data/SlBindState';
import { ScreenOffAnimationManager } from './component/subviewcontrol/ScreenOffAnimationManager';
import lazy { TripleFoldExpandAnimationVc } from './component/subviewcontrol/TripleFoldExpandAnimationVc';
import { OuterHomeManagerUtil } from './utils/OuterHomeManagerUtil';
import { PowerSaveModeManager } from '@ohos/screenlockcommon/src/main/ets/manager/PowerSaveModeManager';

const TAG = 'SCBScreenLock';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 锁屏根控件
 */
@Component
export struct SCBScreenLock {
  private persistentId: number = 0;
  private screenLockVm?: SCBScreenLockVm;
  private readonly rootVc: RootVc = new RootVc(); // 锁屏内部视图控制器
  private readonly viewController: BaseViewController = new BaseViewController(ViewType.KEYGUARD); // 锁屏0层控件面板控制器
  private systemSceneSession?: SCBSystemSceneSession;
  private readonly _screenPropertyChangeCallback: DisplayStateListener = {
    onScreenPropertyChange: (screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason) => {
      log.showInfo('onScreenPropertyChange');
      this.isFoldExpand = DisplayStateManager.getInstance().isFoldExpanded();
      this.slBindState?.setFoldExpandState(this.isFoldExpand);
      OuterHomeManagerUtil.getInstance().setIsSmallOuterScreen(reason);
      slComStateMgr.updateScreenBp(screenProperty.width, screenProperty.height);
      this.gridWidth = clockLayoutHelper.getLayoutGridWidth(DisplayStateManager.getInstance().isPortrait());
      Trace.start(Trace.CORE_METHOD_SCREEN_PROPERTY_CHANGE_KEYGUARD);
      if (reason === SCBPropertyChangeReason.CHANGE_MODE ||
        reason === SCBPropertyChangeReason.FOLD_SCREEN_ROTATION ||
        reason === SCBPropertyChangeReason.PAGE_ROTATION ||
        reason === SCBPropertyChangeReason.FOLD_TO_EXPAND ||
        reason === SCBPropertyChangeReason.EXPAND_TO_FOLD ||
        reason === SCBPropertyChangeReason.FOLD_LANDSCAPE_START ||
        (reason === SCBPropertyChangeReason.ROTATION && this.systemSceneSession?.isRotatable)) {
        this.viewController.updateRect({
          left: 0,
          top: 0,
          width: px2vp(screenProperty.width),
          height: px2vp(screenProperty.height)
        });
      }
      Trace.end(Trace.CORE_METHOD_SCREEN_PROPERTY_CHANGE_KEYGUARD);
    }
  };

  @Link screenProp: SCBScreenProperty;
  @Provide isWallPaperEffectFreeze: boolean = false; // 解决性能问题
  @Provide wallPaperEffectOpacity: number = Constants.DEFAULT_WALLPAPER_OPACITY; // 模糊透明度，解锁进入时使用
  @Provide isFoldExpand: boolean = false;
  @Provide gridWidth: number = 0;
  @State lockManifestParam: LockManifest = defaultManifestParam;
  @State slBindState: SlBindState = slStateHelper.getSlBindState();

  /**
   * 背景模糊VM
   */
  @State screenLockBlurButtonVM: ScreenLockBlurButtonVM = screenLockBlurButtonVM;
  @Provide ntfSettingsDialogClose: boolean = true;
  @Provide closeNtfDialogClose: boolean = true;
  @Provide ntfSilenceDialogClose: boolean = true;
  @Provide pinTopLimitDialogClose: boolean = true;
  @StorageLink('folderStatus') @Watch('onFoldStatusChange') foldStatus: number = AppStorage.get<number>('folderStatus') as number;
  @State @Watch('onWallpaperDataChange') wallpaperData: WallpaperData = WallpaperManager.getInstance().wallpaperData;
  @State wallpaperScale: number = 1;

  onFoldStatusChange(): void {
    DisplayStateManager.getInstance().updateFoldStatus();
  }

  onWallpaperDataChange(): void {
    log.showInfo(`showBackWallpaper:${this.wallpaperData?.showBackWallpaper}`)
    this.wallpaperScale = this.wallpaperData?.showBackWallpaper ? 0.8 : 1;
  }

  aboutToAppear(): void {
    log.showInfo('aboutToAppear start.');
    Trace.start(Trace.CORE_METHOD_SCREEN_LOCK_INIT);
    this.viewController.updateId(this.persistentId);
    ViewManagerPolicy.registerViewController(ViewType.KEYGUARD, this.viewController);

    DisplayStateManager.getInstance().init(this.persistentId);
    DisplayStateManager.getInstance().setScreenProperty(this.screenProp);
    DisplayStateManager.getInstance().registerObserver(this._screenPropertyChangeCallback);
    PowerSaveModeManager.getInstance().init();
    // 熄屏动画
    ScreenOffAnimationManager.getInstance().init();

    this.rootVc.init(Object({
      persistentId: this.persistentId,
      context: getContext(this),
      uiContext: this.getUIContext()
    }));
    this.screenLockVm = new SCBScreenLockVm(this.persistentId);
    this.screenLockVm.init();

    slWallpaperMgr.init();
    if (DeviceHelper.isThreeFoldProduct()) {
      TripleFoldExpandAnimationVc.getInstance().registerTripleFoldExpandAnimation();
    }
    Trace.end(Trace.CORE_METHOD_SCREEN_LOCK_INIT);
  }

  aboutToDisappear(): void {
    log.showInfo('aboutToDisappear');
    this.rootVc.release();
    this.screenLockVm?.release();
    DisplayStateManager.getInstance().unRegisterObserver(this._screenPropertyChangeCallback);
    DisplayStateManager.getInstance().release();
    PowerSaveModeManager.getInstance().release();
    ScreenOffAnimationManager.getInstance().release();
    slWallpaperMgr.release();
    if (DeviceHelper.isThreeFoldProduct()) {
      TripleFoldExpandAnimationVc.getInstance().unRegisterTripleFoldExpandAnimation();
    }
  }

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      if (!this.slBindState.getBlankScreen()) {
        MainPageView({
          persistentId: this.persistentId,
          screenProp: this.screenProp,
          lockManifestParam: this.lockManifestParam
        })
        NotificationSettingBtn({
          type: NotificationType.TYPE_PHONE_KEYGUARD
        });

        // 锁屏通知item侧滑设置弹框
        if (SlStateBaseMgr.isV2Enable()) {
          ImmersiveNtfSettingDialogView()
        }

        BouncerView({
          persistentId: this.persistentId,
          screenProp: this.screenProp
        })
      }
    }
    .id(COMPONENT_ID_SCREEN_LOCK_ROOT)
    .onAppear(() => {
      log.showInfo('SCBScreenLockNew onAppear.');
    })
    .onKeyEvent((event?: KeyEvent) => {
      this.screenLockVm?.handleKeyEvent(event);
    })
    .width('100%')
    .height('100%')
    .backgroundColor(this.slBindState.getBlankScreen() ? 'rgba(0, 0, 0, 1)' : '')
  }
}