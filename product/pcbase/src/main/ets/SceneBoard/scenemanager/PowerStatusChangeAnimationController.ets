/**
 * Copyright (c) 2023-2023 Huawei Device Co., Ltd.
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
import curves from '@ohos.curves';
import SystemPanelModel from '../systempanel/model/SystemPanelModel';
import screenLockMediator from '../screenlock/refactor/ScreenLockMediator';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { PowerStatusController, sSCBOobeManager, SCBKeyboardManager } from '@ohos/windowscene';
import { PowerStatus } from '@ohos/commonconstants';
import power from '@ohos.power';
import { osAccount } from '@kit.BasicServicesKit';

const TAG: string = 'PowerStatusChangeAnimationController';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);
const LOGOUT_IN_PROGRESS_KEY: string = 'powerStatusLogoutInProgress';

export default class PowerStatusChangeAnimationController extends PowerStatusController {
  public static readonly DEFAULT_BLUR_RADIUS: number = 0;

  public static readonly BLUR_RADIUS: number = 0;

  public static readonly DEFAULT_SCALE_RATIO: number = 1;

  public static readonly DEFAULT_OPACITY_RATIO: number = 1;

  public static readonly OPACITY_RATIO: number = 0;

  public static readonly DEFAULT_TIMEOUT: number = 0;

  public static readonly DEFAULT_FINISH: Function = (): void => {};

  public static readonly VISION_CENTER_RATIO_X: number = 0.5;

  public static readonly VISION_CENTER_RATIO_Y: number = 0.4;

  // Animation params for window scenes
  public static readonly SCENE_ANIMATION_GROUP_COUNT: number = 3;

  public static readonly SCENE_COUNT_RATIO_GROUP_1: number = 1;

  public static readonly SCENE_SCALE_RATIO_GROUP_1: number = 1;

  public static readonly SCENE_DURATION_GROUP_1: number = 0;

  public static readonly SCENE_CURVE_GROUP_1: ICurve = curves.cubicBezierCurve(0, 0, 0, 1);

  public static readonly SCENE_COUNT_RATIO_GROUP_2: number = 1;

  public static readonly SCENE_SCALE_RATIO_GROUP_2: number = 1;

  public static readonly SCENE_DURATION_GROUP_2: number = 0;

  public static readonly SCENE_CURVE_GROUP_2: ICurve = curves.cubicBezierCurve(0, 0, 0, 1);

  public static readonly SCENE_SCALE_RATIO_GROUP_3: number = 1;

  public static readonly SCENE_DURATION_GROUP_3: number = 0;

  public static readonly SCENE_CURVE_GROUP_3: ICurve = curves.cubicBezierCurve(0, 0, 0, 1);

  public static closeSceneArray(callback: Function, duration: number, curve: ICurve): void {
    PowerStatusChangeAnimationController.doClose(callback,
      PowerStatusChangeAnimationController.DEFAULT_TIMEOUT, duration, curve,
      PowerStatusChangeAnimationController.DEFAULT_FINISH);
  }

  // Animation params for icon and FA card
  public static readonly DESKTOP_SCALE_RATIO: number = 0.85;

  private static readonly DESKTOP_DURATION: number = 350;

  private static readonly DESKTOP_CURVE: ICurve = curves.cubicBezierCurve(0.20, 0.00, 0.45, 0.60);

  public static closeDeskTop(callback: Function): void {
    PowerStatusChangeAnimationController.doClose(callback,
      PowerStatusChangeAnimationController.DEFAULT_TIMEOUT,
      PowerStatusChangeAnimationController.DESKTOP_DURATION,
      PowerStatusChangeAnimationController.DESKTOP_CURVE,
      PowerStatusChangeAnimationController.DEFAULT_FINISH);
  }

  // Animation params for status bar & Dock
  private static readonly BAR_OPACITY_DURATION: number = 750;

  private static readonly BAR_OPACITY_CURVE: ICurve = curves.cubicBezierCurve(1.00, 0.00, 0.80, 0.90);

  // Animation params for status bar
  public static closeStatusBar(callback: Function): void {
    PowerStatusChangeAnimationController.doClose(callback,
      PowerStatusChangeAnimationController.DEFAULT_TIMEOUT,
      PowerStatusChangeAnimationController.BAR_OPACITY_DURATION,
      PowerStatusChangeAnimationController.BAR_OPACITY_CURVE,
      PowerStatusChangeAnimationController.DEFAULT_FINISH);
  }

  // Animation params for Dock
  public static closeSmartDock(callback: Function): void {
    PowerStatusChangeAnimationController.doClose(callback,
      PowerStatusChangeAnimationController.DEFAULT_TIMEOUT,
      PowerStatusChangeAnimationController.BAR_OPACITY_DURATION,
      PowerStatusChangeAnimationController.BAR_OPACITY_CURVE,
      PowerStatusChangeAnimationController.SMART_DOCK_FINISH);
  }

  public static readonly SMART_DOCK_FINISH: Function = (): void => {
    const powerStatus: PowerStatus | undefined = AppStorage.get<PowerStatus>('powerStatus');
    if (powerStatus === PowerStatus.LOGOUT) {
      PowerStatusChangeAnimationController.logoutAnimator();
    }
  };

  // Animation params for wallpaper
  public static readonly DESKTOP_WALLPAPER_TIMEOUT: number = 350;

  public static readonly DESKTOP_WALLPAPER_DURATION: number = 600;

  public static readonly DESKTOP_WALLPAPER_CURVE: ICurve = curves.cubicBezierCurve(0.40, 0.00, 0.50, 1);

  private static readonly DESKTOP_WALLPAPER_ON_FINISH: Function = (): void => {
    const powerStatus: PowerStatus | undefined = AppStorage.get<PowerStatus>('powerStatus');
    if (powerStatus === PowerStatus.REBOOT) {
      log.showDebug('do system reboot.');
      SystemPanelModel.reboot();
      return;
    }
    if (powerStatus === PowerStatus.SHUTDOWN) {
      log.showDebug('do system shutdown.');
      SystemPanelModel.shutdown();
      return;
    }
    log.showWarn('system is still running, return.');
  };

  public static closeDeskTopWallpaper(callback: Function): void {
    PowerStatusChangeAnimationController.doClose(callback,
      PowerStatusChangeAnimationController.DESKTOP_WALLPAPER_TIMEOUT,
      PowerStatusChangeAnimationController.DESKTOP_WALLPAPER_DURATION,
      PowerStatusChangeAnimationController.DESKTOP_WALLPAPER_CURVE,
      PowerStatusChangeAnimationController.DESKTOP_WALLPAPER_ON_FINISH);
  }

  // Animation params for dialog
  public static readonly DIALOG_DURATION: number = 200;

  private static doClose(callback: Function, timeout: number, duration: number, curve: ICurve,
                         finish: Function): void {
    animateTo({
      delay: timeout,
      duration: duration,
      curve: curve,
      onFinish: () => {
        finish();
      }
    }, () => {
      callback();
    });
  }

  public static readonly SCENE_RECOVER_DURATION: number = 400;

  public static readonly APP_CENTER_BLUR_DURATION: number = 400;

  public static readonly APP_CENTER_HIDE_DURATION: number = 50;

  public static readonly SHUT_DOWN_PROTECT_TIMEOUT: number = 2000;

  private static instance: PowerStatusChangeAnimationController;

  // Dialog exit animation
  private exitAppDialogAnimation: Function = (): boolean => { return false };

  private exitSpecificSceneAnimation: Function = (): boolean => { return false };

  // Split view exit animation
  private exitSplitViewAnimation: Function = (): boolean => { return false };

  // Full screen exit animation
  private exitFullScreenAnimation: Function = (): boolean => { return false };

  // Recent view exit animation
  private exitRecentViewWithAnimation: Function = (): boolean => { return false };

  // App center view exit animation
  private exitAppCenterWithAnimation: Function = (): boolean => { return false };

  private constructor() {
    super();
  }

  public static getInstance(): PowerStatusChangeAnimationController {
    if (PowerStatusChangeAnimationController.instance == null) {
      PowerStatusChangeAnimationController.instance = new PowerStatusChangeAnimationController();
    }
    return PowerStatusChangeAnimationController.instance;
  }

  public changePowerStatus(status: PowerStatus): void {
    if (sSCBOobeManager.isOobeActivated()) {
      log.showError('now is in oobe status, change power status directly.');
      this.changePowerStatusDirectly(status);
      return;
    }
    let session = SCBKeyboardManager.getInstance().getSystemKeyboardSession();
    session?.setVisibility(false);
    const timeout = this.getTimeout();
    log.showDebug('registerShutdownCallback, timeout is ' + timeout);
    setTimeout(() => {
      AppStorage.setOrCreate('powerStatus', status);
    }, timeout);

    // Protect shutdown process from crash of shutdown animation
    setTimeout(() => {
      this.changePowerStatusDirectly(status);
    }, PowerStatusChangeAnimationController.SHUT_DOWN_PROTECT_TIMEOUT);
  }

  private changePowerStatusDirectly(status: PowerStatus): void {
    if (status === PowerStatus.REBOOT) {
      log.showDebug('do reboot directly.');
      power.reboot('reboot_by_user');
    } else if (status === PowerStatus.SHUTDOWN) {
      log.showDebug('do shutdown directly.');
      power.shutdown('shutdown_by_user');
    } else if (status === PowerStatus.HIBERNATE) {
      log.showDebug('do hibernate directly.');
    } else if (status === PowerStatus.LOGOUT) {
      log.showDebug('do logout directly.');
      PowerStatusChangeAnimationController.logoutAnimator();
    }
  }

  private static showLogoutKeyguardFallback(reason: string): void {
    log.showWarn(`show logout keyguard fallback, reason:${reason}`);
    AppStorage.setOrCreate('powerStatus', PowerStatus.RUNNING);
    AppStorage.setOrCreate(LOGOUT_IN_PROGRESS_KEY, false);
    try {
      screenLockMediator.showKeyGuardWithoutLockStatusChange();
    } catch (error) {
      log.showError(`show logout keyguard fallback fail! code: ${error?.code}, message: ${error?.message}`);
    }
  }

  public registerExitAppDialogCallback(callback: Function): void {
    this.exitAppDialogAnimation = callback;
  }

  public registerExitSpecificSceneCallback(callback: Function): void {
    this.exitSpecificSceneAnimation = callback;
  }

  public registerExitSplitViewCallback(callback: Function): void {
    this.exitSplitViewAnimation = callback;
  }

  public registerExitFullScreenCallback(callback: Function): void {
    this.exitFullScreenAnimation = callback;
  }

  public registerExitAppCenterCallback(callback: Function): void {
    this.exitAppCenterWithAnimation = callback;
  }

  public registerExitRecentViewCallback(callback: Function): void {
    this.exitRecentViewWithAnimation = callback;
  }

  private getTimeout(): number {
    // AppCenter hide animation duration 450
    // RecentView hide animation duration 600, but it use spring motion
    // Scene recover animation duration 400
    // Dock show animation duration 400
    // StatusBar has no show animation
    return Math.max(this.getWindowRecoverTimeout(), this.getHideTimeout(), this.getExitDialogTimeout());
  }

  private getWindowRecoverTimeout(): number {
    let timeout = 0;
    const windowTimeout = PowerStatusChangeAnimationController.SCENE_RECOVER_DURATION;

    // Handle split view back to desktop
    const hasRunExitSplitView: boolean = this.exitSplitViewAnimation();

    // Handle full screen back to desktop
    const hasRunExitFullScreen: boolean = this.exitFullScreenAnimation();

    if (hasRunExitSplitView || hasRunExitFullScreen) {
      timeout = windowTimeout;
    }
    return timeout;
  }

  private getHideTimeout(): number {
    let timeout = 0;
    const appCenterTimeout = PowerStatusChangeAnimationController.APP_CENTER_BLUR_DURATION +
      PowerStatusChangeAnimationController.APP_CENTER_HIDE_DURATION;

    // Handle app center back to desktop
    const hasRunHideAppCenter: boolean = this.exitAppCenterWithAnimation();

    // Handle recent view back to desktop
    const hasRunExitRecentView: boolean = this.exitRecentViewWithAnimation();

    if (hasRunHideAppCenter || hasRunExitRecentView) {
      timeout = appCenterTimeout;
    }
    return timeout;
  }

  private getExitDialogTimeout(): number {
    let timeout = 0;
    const exitDialogTimeout = PowerStatusChangeAnimationController.DIALOG_DURATION;

    // Handle exit app dialog
    const hasRunExitAppDialog: boolean = this.exitAppDialogAnimation();

    // Handle exit specific scene dialog e.g AI
    const hasRunExitSpecificSceneDialog: boolean = this.exitSpecificSceneAnimation();

    if (hasRunExitAppDialog || hasRunExitSpecificSceneDialog) {
      timeout = exitDialogTimeout;
    }
    return timeout;
  }

  private static async logoutAnimator(): Promise<void> {
    if (AppStorage.get<PowerStatus>('powerStatus') !== PowerStatus.LOGOUT) {
      log.showWarn('power status is not logout, skip logout request.');
      return;
    }
    if (AppStorage.get<boolean>(LOGOUT_IN_PROGRESS_KEY)) {
      log.showWarn('logout already in progress, skip duplicate request.');
      return;
    }
    AppStorage.setOrCreate(LOGOUT_IN_PROGRESS_KEY, true);
    log.showInfo('start logout');
    let accountManager: osAccount.AccountManager = osAccount.getAccountManager();
    try {
      let currentUserId: number = await accountManager.getOsAccountLocalId();
      log.showInfo(`logout localUserId:${currentUserId}`);
      await accountManager.deactivateOsAccount(currentUserId);
    } catch (error) {
      log.showError(`logout fail! code: ${error?.code}, message: ${error?.message}`);
      PowerStatusChangeAnimationController.showLogoutKeyguardFallback('deactivate account failed');
    } finally {
      setTimeout(() => {
        AppStorage.setOrCreate(LOGOUT_IN_PROGRESS_KEY, false);
      }, PowerStatusChangeAnimationController.SHUT_DOWN_PROTECT_TIMEOUT);
    }
  }
}
