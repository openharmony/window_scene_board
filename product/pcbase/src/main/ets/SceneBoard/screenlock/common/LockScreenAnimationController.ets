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
import { Log } from '@ohos/basicutils';
import { DeviceHelper, HiDfxEventUtil, ViewManagerPolicy, ViewType } from '@ohos/frameworkwrapper';
import ScreenLockService from '../refactor/ScreenLockService';
import { AnimationController, CallbackParameter } from '../../control/animationcontroller/AnimationController';

const TAG: string = 'LockScreenAnimationController';

export default class LockScreenAnimationController extends AnimationController {
  public static readonly DEFAULT_BLUR_RADIUS: number = 0;

  public static readonly BLUR_RADIUS: number = 0;

  public static readonly DEFAULT_OPACITY_RATIO: number = 0;

  public static readonly OPACITY_RATIO: number = 0;

  public static readonly DEFAULT_SCALE_RATIO: number = 0;

  public static readonly DESKTOP_WALLPAPER_SCALE_RATIO: number = 0;

  public static readonly SCREEN_LOCK_WALLPAPER_SCALE_RATIO: number = 0;

  public static readonly DEFAULT_TRANSLATE: number = 0;

  public static readonly DEFAULT_DELAY: number = 0;

  public static readonly DEFAULT_FINISH = (): void => {};

  public static readonly VISION_CENTER_RATIO_X: number = 0;

  public static readonly VISION_CENTER_RATIO_Y: number = 0;

  private readonly COMM_CURVE: ICurve = curves.cubicBezierCurve(0, 0, 0, 0);

  // Animation params for date view
  public static readonly DATE_BLUR_RADIUS: number = 0;
  public static readonly DATE_SCALE_RATIO: number = 0;
  public static readonly DATE_HEIGHT: string = '0vp';
  public static readonly DATE_TRANSLATE: string = '-' + LockScreenAnimationController.DATE_HEIGHT;
  public static readonly DATE_DELAY: number = 0;

  // Animation params for time view
  public static readonly TIME_BLUR_RADIUS: number = 0;
  public static readonly TIME_SCALE_RATIO: number = 0;
  public static readonly TIME_SCALE_CENTER_X: string = '0%';
  public static readonly TIME_SCALE_CENTER_Y: string = '0%';
  public static readonly TIME_TRANSLATE: string = '0vp';
  public static readonly CLOCK_TIME_DELAY: number = 0;

  // Animation params for user item
  public static readonly USER_ITEM_SCALE_RATIO: number = 0;
  public static readonly USER_ITEM_SIZE: number = 0;
  public static readonly USER_ITEM_TRANSLATE: string = '0vp';
  public static readonly USER_ITEM_DELAY: number = 0;
  public static readonly LOCK_SCREEN_STATUS_TRANSLATE: string = '0vp';

  // Animation params for password
  public static readonly PASSWORD_SCALE_RATIO: number = 0;
  public static readonly PASSWORD_DELAY: number = 0;
  public static readonly PASSWORD_TRANSLATE: string = '0vp';

  private readonly LOCK_SCREEN_STATUS_FINISH = (): void => {
    Log.showInfo(TAG, 'start hide screenLock');
    AppStorage.setOrCreate('isLockAnimationStart', false);
    ViewManagerPolicy.hideView(ViewType.KEYGUARD);
    this.isUnlocking = false;
    if (ScreenLockService.getLock()) {
      setTimeout(() => {
        if (ScreenLockService.getLock()) {
          Log.showInfo(TAG, `start show screenLock : isLock: ${AppStorage.get('isLock')}`);
          ViewManagerPolicy.showView(ViewType.KEYGUARD);
        }
      }, 0);
    }
  }

  public static readonly SCENE_COUNT_GROUP_1: number = 0;
  public static readonly SCENE_SCALE_RATIO_GROUP_1: number = 0;
  public static readonly SCENE_DELAY_GROUP_1: number = 0;
  public static readonly SCENE_CURVE_GROUP_1: ICurve = curves.interpolatingSpring(0, 0, 0, 0);

  public static readonly SCENE_COUNT_GROUP_2: number = 0;
  public static readonly SCENE_SCALE_RATIO_GROUP_2: number = 0;
  public static readonly SCENE_DELAY_GROUP_2: number = 0;
  public static readonly SCENE_CURVE_GROUP_2: ICurve = curves.interpolatingSpring(0, 0, 0, 0);

  public static readonly SCENE_SCALE_RATIO_GROUP_3: number = 0;
  public static readonly SCENE_DELAY_GROUP_3: number = 0;
  public static readonly SCENE_CURVE_GROUP_3: ICurve = curves.interpolatingSpring(0, 0, 0, 0);

  // Animation params for desktop app icon
  public static readonly DESKTOP_SCALE_RATIO: number = 0;
  public static readonly DESKTOP_DELAY: number = 0;

  // Animation params for status bar
  public static readonly BAR_SCALE_RATIO: number = 0;
  public static readonly BAR_DELAY: number = 0;

  // Callback name for lock screen
  public static readonly LOCK_SCREEN_STATUS_CALLBACK : string = 'lockScreenStatusCallback';
  public static readonly CLOCK_TIME_CALLBACK : string = 'clockTimeCallback';
  public static readonly DATE_CALLBACK : string = 'dateCallback';
  public static readonly USER_ITEM_CALLBACK : string = 'userItemCallback';
  public static readonly PASSWORD_CALLBACK : string = 'passwordCallback';
  public static readonly LOCK_SCREEN_WALLPAPER_CALLBACK : string = 'lockScreenWallpaperCallback';
  public static readonly SCREEN_MASK_CALLBACK : string = 'screenMask';
  // Callback name for desktop
  public static readonly STATUS_CALLBACK : string = 'statusCallback';
  public static readonly DOCK_CALLBACK : string = 'dockCallback';
  public static readonly HOPPER_CENTRAL_LOGO : string = 'centralLogoCallback';
  public static readonly SCENE_ARRAY_CALLBACK : string = 'sceneArrayCallback';
  public static readonly DESKTOP_CALLBACK : string = 'desktopCallback';
  public static readonly WALLPAPER_CALLBACK : string = 'wallpaperCallback';

  private static instance: LockScreenAnimationController;
  private _isPlayShieldAnimation: boolean = false;

  public set isPlayShieldAnimation(value: boolean) {
    this._isPlayShieldAnimation = value;
  }

  public get isPlayShieldAnimation(): boolean {
    return this._isPlayShieldAnimation;
  }

  public isPlayDefaultUnlockAnimation(): boolean {
    return !this._isPlayShieldAnimation;
  }

  public getUnlockingStatus(): boolean {
    return this.isUnlocking;
  }

  public doLockScreenFinishAnimation(): void {
    this.LOCK_SCREEN_STATUS_FINISH();
  }

  public static getInstance(): LockScreenAnimationController {
    if (LockScreenAnimationController.instance == null) {
      LockScreenAnimationController.instance = new LockScreenAnimationController();
    }
    return LockScreenAnimationController.instance;
  }

  private constructor() {
    super();
    this.init();
  }

  private init(): void {
    //  screen lock status
    LockScreenAnimationController.callbackMap.set(LockScreenAnimationController.LOCK_SCREEN_STATUS_CALLBACK,
      new CallbackParameter((): void =>{}, this.COMM_CURVE, 0, 0));

    // screen lock password
    LockScreenAnimationController.callbackMap.set(LockScreenAnimationController.PASSWORD_CALLBACK,
      new CallbackParameter((): void =>{}, this.COMM_CURVE, 0, 0));

    // screen lock time
    LockScreenAnimationController.callbackMap.set(LockScreenAnimationController.CLOCK_TIME_CALLBACK,
      new CallbackParameter((): void =>{}, this.COMM_CURVE, 0, 0));

    // screen lock date
    LockScreenAnimationController.callbackMap.set(LockScreenAnimationController.DATE_CALLBACK,
      new CallbackParameter((): void =>{}, this.COMM_CURVE, 0, 0, this.LOCK_SCREEN_STATUS_FINISH));

    // screen lock user item
    LockScreenAnimationController.callbackMap.set(LockScreenAnimationController.USER_ITEM_CALLBACK,
      new CallbackParameter((): void =>{}, this.COMM_CURVE, 0, 0));

    // Lock screen wallpaper
    LockScreenAnimationController.callbackMap.set(LockScreenAnimationController.LOCK_SCREEN_WALLPAPER_CALLBACK,
      new CallbackParameter((): void =>{}, this.COMM_CURVE, 0, 0));

    // desktop wallpaper
    LockScreenAnimationController.callbackMap.set(LockScreenAnimationController.WALLPAPER_CALLBACK,
      new CallbackParameter((): void =>{}, this.COMM_CURVE, 0, 0));

    // dock
    LockScreenAnimationController.callbackMap.set(LockScreenAnimationController.DOCK_CALLBACK,
      new CallbackParameter((): void =>{}, this.COMM_CURVE, 0, 0));

    LockScreenAnimationController.callbackMap.set(LockScreenAnimationController.HOPPER_CENTRAL_LOGO,
      new CallbackParameter((): void =>{}, this.COMM_CURVE, 0, 0));

    // desktop
    LockScreenAnimationController.callbackMap.set(LockScreenAnimationController.DESKTOP_CALLBACK,
      new CallbackParameter((): void => {}, curves.interpolatingSpring(0, 0, 0, 0), 0, 0));

    // desktop status bar
    LockScreenAnimationController.callbackMap.set(LockScreenAnimationController.STATUS_CALLBACK,
      new CallbackParameter((): void =>{}, this.COMM_CURVE, 0, 0));

    //  screen lock status
    LockScreenAnimationController.callbackMap.set(LockScreenAnimationController.SCREEN_MASK_CALLBACK,
      new CallbackParameter((): void =>{}, this.COMM_CURVE, 0, 0));
  }
}
