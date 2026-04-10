/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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

import { LengthMetrics } from '@ohos.arkui.node';
import { LogDomain, LogHelper, Trace } from '@ohos/basicutils';
import StyleConfiguration from '../common/StyleConfiguration';
import { ScreenlockComponentStyle } from '../common/StyleConfiguration';
import BatteryPic from '@ohos/batterycomponent/src/main/ets/pc/pages/batteryPic';
import BatteryStyleConfiguration from '@ohos/batterycomponent/src/main/ets/default/common/StyleConfiguration';
import { BatteryPicStyle } from '@ohos/batterycomponent/src/main/ets/default/common/StyleConfiguration';
import InputMethodSubTypeIcon from '@ohos/inputmethodcomponent/src/main/ets/default/pages/inputMethodSubTypeIcon';
import LockScreenAnimationController from '../common/LockScreenAnimationController';
import ScreenLockPowerIcon from '../component/ScreenLockPowerIcon';
import mBatteryModel, { BatterySocVm } from '@ohos/batterycomponent/src/main/ets/default/batteryModel';
import { PcResourceManager } from '../../../common/manager/ResourceManager';
import { OpenCoverAnimationController } from '../common/OpenCoverAnimationController';
import { BusinessError } from '@ohos.base';
import ScreenLockSuperPrivacyIcon from '../component/ScreenLockSuperPrivacyIcon';
import { SwitchAccountAnimationParameter } from '../pages/SwitchAccountAnimation'
import { systemDateTime } from '@kit.BasicServicesKit';
import Constants from '../common/Constants';
import { ScreenLockWifiIcon } from '../component/ScreenLockWifiIcon';

const TAG = 'ScreenLock-StatusBar'
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);
const OFFSET_Y = 0;
const KEY_BATTERY_KEY = 'ScreenLock-StatusBar_BatteryIcon';
// 深色主题下图标颜色
const DARK_CONTENT_COLOR: string = '#000000';
// 亮色主题下图标颜色
const BRIGHT_CONTENT_COLOR: string = '#FFFFFF';

enum IconPosEnum {
  START,
  MIDDLE,
  END,
}

interface IconConfig {
  showBatterySoc: boolean
}
const COMPONENT_ID_SCREEN_LOCK_STATUS_BAR = TAG;

/**
 * PC ScreenLockStatusBar
 */
@Component
export default struct StatusBar {
  @Require @Prop @Watch('switchAccountAnimation') isSwitchAnimation: boolean;
  @State private style: ScreenlockComponentStyle = StyleConfiguration.getScreenlockComponentStyle();
  @Provide private contentColor: string = '';
  @Link isPowerMenuPanelShowed: boolean;
  // For unlock screen animation
  @State statusViewBlur: number = LockScreenAnimationController.DEFAULT_BLUR_RADIUS;
  @State statusViewOpacity: number = LockScreenAnimationController.DEFAULT_OPACITY_RATIO;
  @State statusViewScale: number = LockScreenAnimationController.DEFAULT_SCALE_RATIO;
  @State statusViewTranslate: number | string = LockScreenAnimationController.DEFAULT_TRANSLATE;
  @State mIconConfig: IconConfig = {
    showBatterySoc: false,
  };
  @Consume pwdNeedFocus: boolean;
  @Consume focusAfterBoot: boolean;
  // @State superPrivacyMode: superPrivacyManager.SuperPrivacyMode = superPrivacyManager.SuperPrivacyMode.OFF;
  @State superPrivacyMode: number = 0;
  @StorageProp('isLock') @Watch('onLock') isLock: boolean = true;
  @StorageProp('isScreenLockWallpaperBrightOrDark') @Watch('onBrightChange') isBright: boolean = true;
  private resourceMgr: PcResourceManager = new PcResourceManager();
  private batteryStyle: BatteryPicStyle = BatteryStyleConfiguration.getBatteryPicStyleForScreenLock();
  private socVm: BatterySocVm = new BatterySocVm();

  private onSuperPrivacyModeChange: Callback<ESObject> =
    (mode: ESObject) => {
      this.superPrivacyMode = mode;
    }

  private onLock(): void {
    if (this.isLock) {
      this.resetParam();
    }
  }

  /**
   * 当 isBright 发生变化的时候触发, 更新背景颜色
   */
  private onBrightChange(): void {
    this.contentColor = this.isBright ? DARK_CONTENT_COLOR : BRIGHT_CONTENT_COLOR;
  }

  private resetParam(): void {
    if (AppStorage.get('isLockAnimationStart')) {
      return;
    }
    log.showInfo('resetParam');
    this.statusViewBlur = LockScreenAnimationController.DEFAULT_BLUR_RADIUS;
    this.statusViewOpacity = LockScreenAnimationController.DEFAULT_OPACITY_RATIO;
    this.statusViewScale = LockScreenAnimationController.DEFAULT_SCALE_RATIO;
    this.statusViewTranslate = LockScreenAnimationController.DEFAULT_TRANSLATE;
  }

  /**
   * @description 电池启用回调
   * @param showBatterySoc
   */
  onBatterySoc(showBatterySoc: boolean) {
    log.showInfo(`onBatterySoc ${showBatterySoc}`);
    this.mIconConfig.showBatterySoc = showBatterySoc;
  }

  /**
   * @description 注册开盖动效
   */
  private registerOpenCoverAnimationCallback(): void {
    OpenCoverAnimationController.getInstance().registerInitParamCallback(
      OpenCoverAnimationController.STATUS_VIEW_ANIMATION, () => {
      this.statusViewOpacity = OpenCoverAnimationController.STATUS_VIEW_OPACITY_BEGIN;
      this.statusViewScale = OpenCoverAnimationController.STATUS_VIEW_SCALE_BEGIN;
      this.statusViewTranslate = OpenCoverAnimationController.STATUS_VIEW_TRANSLATE_Y_BEGIN;
    });
    OpenCoverAnimationController.getInstance().registerAnimationCallback(
      OpenCoverAnimationController.STATUS_VIEW_ANIMATION, () => {
      this.statusViewOpacity = OpenCoverAnimationController.DEFAULT_OPACITY;
      this.statusViewScale = OpenCoverAnimationController.DEFAULT_SCALE;
      this.statusViewTranslate = OpenCoverAnimationController.DEFAULT_TRANSLATE;
    });
  }

  /**
   * @description 取消开盖动效
   */
  private unregisterOpenCoverAnimationCallback(): void {
    OpenCoverAnimationController.getInstance().unregisterCallback(
      OpenCoverAnimationController.STATUS_VIEW_ANIMATION);
  }

  /**
   * @description 企业空间切换账户动效
   */
  private switchAccountAnimation(): void {
    if (this.isSwitchAnimation) {
      log.showInfo(`Start Animation`);
      this.statusViewOpacity = SwitchAccountAnimationParameter.statusBarOpacityBegin;
      this.statusViewScale = SwitchAccountAnimationParameter.statusBarScaleBegin;
      this.statusViewTranslate = SwitchAccountAnimationParameter.statusBarTranslateBegin;
      animateTo({
        delay: SwitchAccountAnimationParameter.statusTime,
        duration: 200 * SwitchAccountAnimationParameter.dynamicEffectRatio,
        curve: Curve.Sharp
      }, () => {
        this.statusViewOpacity = SwitchAccountAnimationParameter.statusBarOpacityEnd;
      });
      animateTo({
        delay: SwitchAccountAnimationParameter.statusTime,
        duration: 400 * SwitchAccountAnimationParameter.dynamicEffectRatio,
        curve: Curve.Friction,
        onFinish: () => {
          Trace.end('SWITCHACCOUNTANIMATION_SCB2');
          Trace.end('SWITCHACCOUNTANIMATION_SCBLOCK_EAGERLY');
          // 进锁屏情况下，等待动效执行完，允许四指滑动
          let animationTime = systemDateTime.getUptime(systemDateTime.TimeType.ACTIVE, false).toString();
          AppStorage.setOrCreate('switchAccountState', animationTime);
          AppStorage.setOrCreate('isCanSlide', true);
        }
      }, () => {
        this.statusViewScale = SwitchAccountAnimationParameter.statusBarScaleEnd;
        this.statusViewTranslate = SwitchAccountAnimationParameter.statusBarTranslateEnd;
      });
    }
  }

  /**
   * StatusBar aboutToAppear
   */
  public aboutToAppear(): void {
    mBatteryModel.initBatteryModel();
    this.batteryStyle.picBodyWidth = $r('app.float.screenLock_battery_width');
    this.batteryStyle.picBodyHeight = $r('app.float.screenLock_battery_height');
    this.switchAccountAnimation();
    this.style.initStyle();
    this.onBrightChange();

    LockScreenAnimationController.getInstance().registerCallback(
      LockScreenAnimationController.LOCK_SCREEN_STATUS_CALLBACK, () => {
      this.statusViewOpacity = LockScreenAnimationController.OPACITY_RATIO;
      this.statusViewTranslate = LockScreenAnimationController.LOCK_SCREEN_STATUS_TRANSLATE;
    });

    this.socVm.init(this);
    this.registerOpenCoverAnimationCallback();

    try {
      // superPrivacyManager.on('superPrivacyModeChange', this.onSuperPrivacyModeChange);
    } catch (err) {
      log.showError(`superPrivacyManager listen superPrivacyModeChange error code is ${(err as BusinessError).code}`);
    }
    log.showInfo('aboutToAppear');
  }

  /**
   * StatusBar aboutToDisappear
   */
  public aboutToDisappear(): void {
    this.socVm.destroy();
    LockScreenAnimationController.getInstance()
      .unregisterCallback(LockScreenAnimationController.LOCK_SCREEN_STATUS_CALLBACK);
    this.unregisterOpenCoverAnimationCallback();
    try {
      // superPrivacyManager.off('superPrivacyModeChange', this.onSuperPrivacyModeChange);
    } catch (err) {
      log.showError(`superPrivacyManager unlisten superPrivacyModeChange error code is ${(err as BusinessError).code}`);
    }
    log.showInfo('aboutToDisappear');
  }

  /**
   * StatusBar build
   */
  public build(): void {
    Row() {
      ScreenLockPowerIcon({
        isPowerMenuPanelShowed: this.isPowerMenuPanelShowed,
        resourceMgr: this.resourceMgr
      })

      Row() {
        /*if (this.superPrivacyMode === superPrivacyManager.SuperPrivacyMode.ALWAYS_ON) {
          Row() {
            ScreenLockSuperPrivacyIcon({})
          }
          .iconRowStyle(IconPosEnum.START)
          .alignItems(VerticalAlign.Center)
          .justifyContent(FlexAlign.Center)
          .onTouch((event: TouchEvent) => {
            event.stopPropagation();
            this.isPowerMenuPanelShowed = false;
          })
        }*/

        Row() {
          InputMethodSubTypeIcon({
            style: {
              statusBarInputMethodWidth: Constants.STATUSBAR_INPUT_METHOD_WIDTH,
              statusBarInputMethodHeight: Constants.STATUSBAR_INPUT_METHOD_HEIGHT,
              hadStatusBarInputMethodWidth: Constants.STATUSBAR_INPUT_METHOD_WIDTH,
              hadStatusBarInputMethodHeight: Constants.STATUSBAR_INPUT_METHOD_HEIGHT,
            },
            isScreenLock: true
          })
        }
        .iconRowStyle()
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .onTouch((event: TouchEvent) => {
          event.stopPropagation();
          this.isPowerMenuPanelShowed = false;
        })

        Row() {
          BatteryPic({
            style: this.batteryStyle,
            isScreenLock: true,
            showBatterySoc: this.mIconConfig.showBatterySoc,
            resourceMgr: this.resourceMgr
          })
        }
        .id(KEY_BATTERY_KEY)
        .iconRowStyle(IconPosEnum.MIDDLE, 44)
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .onTouch((event: TouchEvent) => {
          event.stopPropagation();
          this.isPowerMenuPanelShowed = false;
        })

        Row() {
          ScreenLockWifiIcon({
            onIconClick: () => {
              this.isPowerMenuPanelShowed = false;
            },
          })
        }
        .iconRowStyle(IconPosEnum.END, 'auto')
      }
      .margin({
        end: LengthMetrics.vp(16)
      })
    }
    .id(COMPONENT_ID_SCREEN_LOCK_STATUS_BAR)
    .focusable(this.focusAfterBoot)
    .onFocus(() => {
      log.showInfo(`StatusBar focus`);
    })
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.SpaceBetween)
    .backgroundColor($r('app.color.transparent'))
    .height('40vp')
    .width('100%')
    .position({ y: OFFSET_Y })
    .opacity(this.statusViewOpacity)
    .scale({
      x: this.statusViewScale,
      y: this.statusViewScale
    })
    .translate({
      y: this.statusViewTranslate
    })
  }
}

@Extend(Row)
function iconRowStyle(pos: IconPosEnum = IconPosEnum.MIDDLE, width: Length = 34) {
  .size({ width: width, height: 34 })
  .constraintSize({ maxWidth: 100 })
  .margin({
    start: LengthMetrics.vp(pos === IconPosEnum.START ? 0 : 2),
    end: LengthMetrics.vp(pos === IconPosEnum.END ? 0 : 2),
  })
}