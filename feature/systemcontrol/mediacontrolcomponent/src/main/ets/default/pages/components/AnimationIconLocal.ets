/*
 * Copyright (c) 2023-2024 Huawei Device Co., Ltd.
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

import animator, { AnimatorResult } from '@ohos.animator';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import { ThreadUtil } from '@ohos/basicutils/src/main/ets/utils/ThreadUtil';
import { DeviceHelper } from '@ohos/frameworkwrapper/src/main/ets/base/DeviceHelper';
import { EvtBus } from '@ohos/frameworkwrapper/src/main/ets/eventbus/EventBus';
import { ConfigurationEvent } from '@ohos/frameworkwrapper/src/main/ets/eventbus/events/Events';
import {
  AodStyleType,
  ImmersiveAodStyle,
} from '@ohos/systemuicommon/src/main/ets/immersivekeyguardcommon/base/interface/ImmersiveAodStyle';
import {
  immersiveKgMgr,
} from '@ohos/systemuicommon/src/main/ets/immersivekeyguardcommon/manager/ImmersiveKeyguardStateManager';
import { ColorModeViewData } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeViewData';
import { ColorModeViewModel } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeViewModel';
import { LengthMetrics } from '@ohos.arkui.node';
import BrightnessUtils from '../../Util/BrightnessUtils'
import { ConfigurationConstant } from '@kit.AbilityKit';
import { ResourceVm } from '@ohos/systemuicommon/src/main/ets/vm/ResourceVm';
import { SystemUIColorVm } from '@ohos/systemuicommon/src/main/ets/vm/SystemUIColorVm';
import { MediaViewModelManager, MediaVMType } from '../../viewmodel/MediaViewModelManager';
import { SysConfigData } from '../../viewmodel/SysConfigData';

const TAG: string = 'AnimationIconLocal';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.MC, TAG);

// size
const CONTAINER_SIZE_MIN: number = 20.5;
const CONTAINER_SIZE_MAX: number = 24;
const LINE_WIDTH: number = 2;
const LINE_HEIGHT: number = 12;
const TRIANGLE_SIZE_MAX: number = 16;
const TRIANGLE_SIZE_MAX_BIG: number = TRIANGLE_SIZE_MAX * 1.02;
const TRIANGLE_MAIN_SIZE_MIN: number = TRIANGLE_SIZE_MAX * 0.3;
const TRIANGLE_SUB_SIZE_MIN: number = TRIANGLE_SIZE_MAX * 0.5;
// position
const MAIN_TRIANGLE_START: number = 3;
const MAIN_TRIANGLE_END: number = 15;
const SUB_TRIANGLE_START: number = -11;
// time
const TRIANGLE_MAIN_TIME: number = 350;
const TRIANGLE_SUB_TIME: number = 134;
const LINE_FIRST_TIME: number = 233;
const LINE_SECOND_TIME: number = 166;

@Component
export default struct AnimationIconLocal {
  private isPC: boolean = DeviceHelper.isPC();
  @Prop active: boolean = true;
  @State scaleValue: number = 1;
  @State canvasWidth: number = CONTAINER_SIZE_MIN;
  @State translateX1: number = MAIN_TRIANGLE_START;
  @State size1: number = TRIANGLE_SIZE_MAX;
  @State translateX2: number = SUB_TRIANGLE_START;
  @State size2: number = TRIANGLE_SUB_SIZE_MIN;
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  @Prop isControlCenter: string;
  @Prop sceneType: string;
  @StorageLink('isSysColor') isSysColor: boolean = true;

  /**
   * AOD显示样式
   */
  @State aodStyle: ImmersiveAodStyle | undefined = immersiveKgMgr.getOneMirrorState().getAodStyle(true);

  private linkAnimator1: AnimatorResult | undefined;
  private linkAnimator2: AnimatorResult | undefined;
  @StorageLink('isMarkingRenderGroupOfControl') isMarkingRenderGroupOfControl: boolean = false; // 增加UI缓存，防止丢帧
  @StorageProp('currColorMode') currColorMode: number = 0;
  uiContext: UIContext = this.getUIContext();
  @State sysConfigData: SysConfigData | undefined = ThreadUtil.isMainThread ?
    MediaViewModelManager.getData(MediaVMType.SYS_CONFIG_DATA, true) as SysConfigData : undefined;

  private onFrame1 = (value: number) => {
    this.canvasWidth = Number(value);
  };

  private onFinish1 = () => {
    try {
      this.linkAnimator2?.play();
    } catch (err) {
      log.showWarn(`linkAnimator2 play error `, err)
    }
  };

  private onFrame2 = (value: number) => {
    this.canvasWidth = Number(value);
  };

  aboutToAppear() {
    this.linkAnimator2 = this.uiContext.createAnimator({
      duration: LINE_SECOND_TIME,
      easing: 'sharp',
      delay: 0,
      fill: 'forwards',
      direction: 'normal',
      iterations: 1,
      begin: CONTAINER_SIZE_MAX,
      end: CONTAINER_SIZE_MIN
    });

    this.linkAnimator1 = this.uiContext.createAnimator({
      duration: LINE_FIRST_TIME,
      easing: 'sharp',
      delay: 0,
      fill: 'forwards',
      direction: 'normal',
      iterations: 1,
      begin: CONTAINER_SIZE_MIN,
      end: CONTAINER_SIZE_MAX
    });

    if (this.linkAnimator1) {
      this.linkAnimator1.onframe = this.onFrame1;
      if (this.linkAnimator2) {
        this.linkAnimator2.onframe = this.onFrame2;
        this.linkAnimator1.onfinish = this.onFinish1;
      }
    }
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisappear')
    if (this.linkAnimator1) {
      this.linkAnimator1.onframe = () => {};
      this.linkAnimator1.onfinish = () => {};
    }
    if (this.linkAnimator2) {
      this.linkAnimator2.onframe = () => {};
    }
    this.linkAnimator1?.finish();
    this.linkAnimator2?.finish();
    this.linkAnimator1 = undefined;
    this.linkAnimator2 = undefined;
    this.onFrame1 = () => {};
    this.onFinish1 = () => {};
    this.onFrame2 = () => {};
  }

  private doFillColor() {
    let isSink: boolean = !!AppStorage.get('isSink');
    log.showInfo('on doFillColor isSink: ' + isSink);
    if (isSink) {
      return '#FFFFFFFF';
    }
    if (this.isControlCenter !== 'center' && this.aodStyle?.isAod) {
      return this.aodStyle.getStyleValue(AodStyleType.MEDIA_BUTTON_COLOR);
    } else {
      if (this.active) {
        if (this.isPC) {
          return $r('app.color.media_control_item_icon_primary');
        } else {
          return !this.isControlCenter ? $r('app.color.media_control_icon_primary') : (this.isControlCenter === 'center' ?
          $r('app.color.media_control_center_icon_primary') : $r('app.color.media_control_item_icon_primary'));
        }
      } else {
        if (this.isPC) {
          return $r('app.color.media_control_center_icon_disable_pc');
        } else {
          return !this.isControlCenter ? $r('app.color.media_control_icon_disable') : (this.isControlCenter === 'center' ?
          $r('app.color.media_control_center_icon_disable') : $r('app.color.media_control_item_icon_disable'));
        }
      }
    }
  }

  private getForegroundBrightnessBrightness() {
    if (this.isPC) {
      return this.active ? this.colorModeViewData?.foregroundPrimaryOptionOnBackground :
        this.colorModeViewData?.foregroundTertiaryGlossOption;
    }
    if (this.sceneType === 'expandMediaInfoCard') {
      return this.colorModeViewData.foregroundPrimaryOption;
    }
    // 隔离pc或tv主线程调用
    let colorMode = ThreadUtil.isMainThread ? this.currColorMode : SystemUIColorVm.instance.colorMode;
    return (this.isControlCenter === 'center' ?
    this.colorModeViewData.foregroundPrimaryOption :
    BrightnessUtils.getInstance().getBrightnessOption(this.isSysColor, this.sceneType,
      colorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK));
  }

  private doAnimation() {
    // canvas
    this.linkAnimator1?.play();
    // triangles position
    this.translateX1 = MAIN_TRIANGLE_START;
    this.translateX2 = SUB_TRIANGLE_START;
    this.uiContext.animateTo({ duration: TRIANGLE_MAIN_TIME, curve: Curve.Friction }, () => {
      this.translateX1 = MAIN_TRIANGLE_END; // triangles main
      this.translateX2 = MAIN_TRIANGLE_START; // triangles sub
    });
    // triangles size
    this.size1 = TRIANGLE_SIZE_MAX;
    this.size2 = TRIANGLE_SUB_SIZE_MIN;
    // triangles main
    this.uiContext.animateTo({ duration: LINE_FIRST_TIME, curve: Curve.Friction }, () => {
      this.size1 = TRIANGLE_MAIN_SIZE_MIN;
    });
    // triangles sub
    this.uiContext.animateTo({
      duration: TRIANGLE_MAIN_TIME,
      curve: Curve.Sharp,
    }, () => {
      this.size2 = TRIANGLE_SIZE_MAX_BIG;
    });
    this.uiContext.animateTo({
      duration: TRIANGLE_SUB_TIME,
      curve: Curve.Sharp,
      delay: TRIANGLE_MAIN_TIME
    }, () => {
      this.size2 = TRIANGLE_SIZE_MAX;
    });
  }

  getPadding(): LocalizedPadding {
    if (this.isControlCenter === 'sinks') {
      return { start: undefined };
    } else if (this.isControlCenter === 'isSmallFoldOuterScreen') {
      return {start: LengthMetrics.vp(6)}
    } else {
      return { start: LengthMetrics.vp(12) }
    }
  }

  isRTL() {
    // 隔离主线程调用
    return ThreadUtil.isMainThread ? !!this.sysConfigData?.isRTL : ResourceVm.instance.isRTL;
  }

  build() {
    Row() {
      RelativeContainer() {
        Row() {
          Image($r('app.media.ic_sing_play'))
            .fillColor(this.doFillColor())
            .foregroundBrightness(this.isControlCenter === 'sinks' ? undefined : ((this.isControlCenter !== 'center' &&
              this.aodStyle?.isAod) ? undefined : this.getForegroundBrightnessBrightness()))
            .width(TRIANGLE_SIZE_MAX)
            .height(TRIANGLE_SIZE_MAX)
            .scale({ x: this.size1 / TRIANGLE_SIZE_MAX, y: this.size1 / TRIANGLE_SIZE_MAX })
            .rotate({ centerX: '50%', centerY: '50%', angle: this.isRTL() ? 180 : 0 })
            .draggable(false)
            .renderGroup(this.aodStyle?.isOneMirror ? false : this.isMarkingRenderGroupOfControl) // 增加UI缓存，防止丢帧
        }
        .size({ width: this.size1, height: this.size1 })
        .translate({ x: this.translateX1 * (this.isRTL() ? -1 : 1) })
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          left: { anchor: '__container__', align: HorizontalAlign.Start }
        })
        .id('row1')
        Row() {
          Image($r('app.media.ic_sing_play'))
            .fillColor(this.doFillColor())
            .foregroundBrightness(this.isControlCenter === 'sinks' ? undefined : ((this.isControlCenter !== 'center' &&
              this.aodStyle?.isAod) ? undefined : this.getForegroundBrightnessBrightness()))
            .width(TRIANGLE_SIZE_MAX)
            .height(TRIANGLE_SIZE_MAX)
            .scale({ x: this.size2 / TRIANGLE_SIZE_MAX, y: this.size2 / TRIANGLE_SIZE_MAX })
            .rotate({ centerX: '50%', centerY: '50%', angle: this.isRTL() ? 180 : 0 })
            .draggable(false)
            .renderGroup(this.aodStyle?.isOneMirror ? false : this.isMarkingRenderGroupOfControl) // 增加UI缓存，防止丢帧
        }
        .size({ width: this.size2, height: this.size2 })
        .translate({ x: this.translateX2 * (this.isRTL() ? -1 : 1) })
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          left: { anchor: '__container__', align: HorizontalAlign.Start }
        })
        .id('row2')
        Row()
          .size({ width: LINE_WIDTH, height: LINE_HEIGHT })
          .backgroundColor(this.doFillColor())
          .foregroundBrightness(this.isControlCenter === 'sinks' ? undefined : ((this.isControlCenter !== 'center' &&
            this.aodStyle?.isAod) ? undefined : this.getForegroundBrightnessBrightness()))
          .borderRadius(LINE_WIDTH / 2)
          .alignRules({
            center: { anchor: '__container__', align: VerticalAlign.Center },
            right: { anchor: '__container__', align: HorizontalAlign.End }
          })
          .margin({ right: 0.5 })
          .id('row3')
      }
      .clip(true)
      .size({ width: this.canvasWidth, height: this.canvasWidth})
      .backgroundColor(Color.Transparent)
      .scale({ x: this.scaleValue, y: this.scaleValue })
    }
    .size({ width: '100%', height: '100%'})
    .padding(this.getPadding())
    .backgroundColor(Color.Transparent)
    .onTouch((event) => {
      if (event?.type !== TouchType.Up) {
        return;
      }
      if (!this.active) {
        return;
      }
      this.doAnimation();
    })
  }
}