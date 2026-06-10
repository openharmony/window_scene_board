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

import { DeviceType } from '../common/model/DeviceType';
import { ContinuityState } from '../common/model/ContinuityState';
import StyleConfiguration, { PluginCardComponentStyle, } from '../common/model/StyleConfiguration';
import lottie, { AnimationItem } from '@ohos/lottie';
import { ColorModeViewData, ColorModeViewModel } from '@ohos/systemuicommon/Index';
import {
  LogDomain,
  LogHelper,
} from '@ohos/basicutils';
import {
  DeviceHelper,
  SystemParamUtils,
} from '@ohos/frameworkwrapper';
import { DropDownAdapter } from '@ohos/systemuicommon/src/main/ets/adapter/DropDownAdapter';
import curves from '@ohos.curves';
import { DeviceShowInfo } from '../common/model/DeviceShowInfo';
import { SymbolIconUtil } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { pluginCardReportUtil } from '../common/PluginCardReportUtil';
import { AccessibilityUtil } from '../common/utils/AccessibilityUtil';
import Constants from '../common/model/Constants';
import { StringUtil } from '../common/model/StringUtil';
import { LengthMetrics, LengthUnit, ColorMetrics } from '@kit.ArkUI';
import { DataType } from '../common/model/DataType';
import { DeviceState } from '@ohos/launchercommon/src/main/ets/constants/CommonConstants';

const TAG: string = 'DeviceContentItem';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
const ICON_SCALE_SIZE: number = 0.78;
const HALF_DEVICE_NUM: number = 1;

@Component
export default struct DeviceContentItem {
  @State deviceType: string = '';
  @State style: PluginCardComponentStyle = StyleConfiguration.getPluginCardComponentStyle();
  @Prop serviceUniqueId: string;
  @State state: ContinuityState = ContinuityState.IDLE;
  @State isRefresh: boolean = true;
  @State deviceName: string = '';
  @State brMac: string = '';
  @Prop isPluginCardHide: boolean;
  @StorageLink('deviceNumber') @Watch('updateDeviceNum') deviceNum: number = 0;
  @StorageLink('isMarkingRenderGroup') isMarkingRenderGroup: boolean = false;
  @State scaleX: number = 1;
  @State scaleY: number = 1;
  @State originalSize: number = 1;
  @State iconOriginalSize: number = 1;
  @State originalNum: number = 0;
  @State updatedSize: Resource = $r('app.float.deviceItem_original_size');
  @StorageLink('foldStatusForOuterScreen')@Watch('onFoldStatusChange') foldStatus: number = AppStorage.get<number>('foldStatusForOuterScreen') as number;
  @State isSmallFoldOuterScreen: boolean = false;
  private viewModel: ColorModeViewModel = ColorModeViewModel.getInstance();
  @State colorModeViewData: ColorModeViewData = this.viewModel.getViewData();
  private setting: RenderingContextSettings = new RenderingContextSettings(true);
  private context2D: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.setting);
  private lottieName: string = 'animate';
  private lottieData: object | null = null;
  @State records: Record<string, object> = {};
  private animationItem: AnimationItem | null = null;
  private previousNum: number = 0;
  private previousUpdatedSize: number = 0;
  private lightOnIntensity: number = 1.0;
  private isHddProduct: boolean = SystemParamUtils.isHddProduct();
  @State bloomValue: number = 0;
  @State lightIntensity: number = 0;
  @State extra: string = '';
  @Prop showInfo: DeviceShowInfo;
  private index: number = -1;
  private accessText: string = '';
  private canvasReady = false;
  private isAboutToDisappear: boolean = false;
  private onIconClick: (showInfo: DeviceShowInfo, index: number) => void = () => {};

  private onFoldStatusChange() {
      return;
  }

  private loadAnimation(isRefresh?: boolean, lottieName?: string): void {
    if (isRefresh && (!lottieName || lottieName === '')) {
      log.showError('refresh: lottieName is null, Failed to play the animation');
      return;
    }
    this.lottieData = this.matchLottieData();
    if (this.lottieData === null) {
      log.showError('lottieData is null, Failed to play the animation');
      return;
    }
    if (this.animationItem === null || isRefresh) {
      if (!isRefresh) {
        this.lottieName = `animate_${this.serviceUniqueId}_${new Date().getTime()}`;
      }
      log.showInfo('play the animation');
      this.animationItem = lottie.loadAnimation({
        container: this.context2D,
        renderer: 'canvas',
        loop: true,
        autoplay: true,
        name: this.lottieName,
        animationData: this.lottieData,
        packageName: Constants.SUPER_DEVICE_PACKAGE_NAME
      })
    }
  }

  private matchLottieData(): object {
    return this.state === ContinuityState.DISCONNECTING ? this.records.disconnect : this.records.connect;
  }

  private getDeviceIcon(type: string): Resource | undefined {
    switch (type) {
      case DeviceType.AUDIO_DEVICE:
      case DeviceType.HEADSET:
      case DeviceType.SPEAKER:
        return this.parseIconRes(this.extra);
      default:
        return pluginCardReportUtil.getDeviceTypeIcon(type);
    }
  }

  private parseIconRes(extra: string): Resource {
    let audioStr = '';
    try {
      audioStr = JSON.parse(extra)['iconRes'];
      if (audioStr.length >= 0) {
        return $r(`${audioStr}`);
      }
    } catch (e) {
      log.showError(`parse extra error, extra:${extra}`);
    }
    return $r(`sys.symbol.earphone_bluetooth`);
  }

  private getStereoRes(extra: string): Resource {
    let audioStr = '';
    try {
      audioStr = JSON.parse(extra)['iconRes'];
    } catch (e) {
      log.showError(`parse extra error, extra:${extra}`);
    }
    if (audioStr.match('stereo') && audioStr.length >= 0) {
      let resStr = audioStr.replace('sys.symbol.', 'app.media.');
      return $r(`${resStr}`);
    }
    return $r(`sys.symbol.earphone_bluetooth`);
  }

  private isStereo(extra: string): boolean {
    let audioStr = '';
    try {
      audioStr = JSON.parse(extra)['iconRes'];
    } catch (e) {
      log.showError(`parse extra error, extra:${extra}`);
    }
    if (!audioStr) {
      return false;
    }
    return audioStr.match('stereo') !== null;
  }

  private isHideDeviceIcon(): boolean {
    switch (this.state) {
      case ContinuityState.PREPARE:
      case ContinuityState.CONNECTING:
      case ContinuityState.DISCONNECTING:
        return true;
      default:
        return false;
    }
  }

  private updateDeviceNum(): void {
    log.info(TAG, 'update device num');
    if (this.isRefresh) {
      if (this.deviceNum === 2) {
        this.updatedSize = this.isSmallFoldOuterScreen ? $r('app.float.deviceItem_changed_fold_outer_size') : $r('app.float.deviceItem_changed_size');
        this.iconOriginalSize = 0.78;
      } else if (this.deviceNum === HALF_DEVICE_NUM && this.iconOriginalSize === ICON_SCALE_SIZE) {
        animateTo({ duration: 200 }, () => {
          this.originalSize = 1;
          this.iconOriginalSize = 1;
          this.updatedSize = $r('app.float.deviceItem_original_size');
        })
      }
      return;
    }
    if (this.deviceNum === 2) {
      animateTo({ duration: 200, delay: 170, curve: curves.interpolatingSpring(0, 1, 200, 23) }, () => {
        this.iconOriginalSize = 0.78;
        this.updatedSize = this.isSmallFoldOuterScreen ? $r('app.float.deviceItem_changed_fold_outer_size') : $r('app.float.deviceItem_changed_size');
      })
    } else if (this.deviceNum === 1 && this.originalNum === 2) {
      animateTo({ duration: 200 }, () => {
        this.originalSize = 1;
        this.iconOriginalSize = 1;
        this.updatedSize = $r('app.float.deviceItem_original_size');
      })
    }
    this.originalNum = this.deviceNum;
  }

  private getLightIntensity(): number {
    return this.isHddProduct ? 0 : this.lightIntensity;
  }

  private getLightBloom(): number {
    return this.isHddProduct ? 0 : this.bloomValue;
  }

  private getTopRate(): BrightnessOptions | undefined {
    return this.colorModeViewData.getTopOption(this.state === ContinuityState.CONNECTED);
  }

  private lightOn(): void {
    animateTo({
      curve: Curve.Smooth,
      duration: 333
    }, () => {
      this.lightIntensity = this.lightOnIntensity;
      this.bloomValue = 1;

    })
  }

  private lightOff(): void {
    // 需要提前恢复canvas大小，不能在动画中恢复，原因是动画中改变canvas大小，动画会抖动
    animateTo({
      curve: Curve.Smooth,
      duration: 333
    }, () => {
      this.lightIntensity = 0;
      this.bloomValue = 0;
    })
  }

  private touchAction = (event: TouchEvent) => {
    if (event.type === TouchType.Down) {
      this.lightOn();
    } else if (event.type === TouchType.Up || event.type === TouchType.Cancel) {
      this.lightOff();
    }
  }

  aboutToAppear(): void {
    log.showInfo(`deviceName: ${StringUtil.getAnonymousData(this.deviceName, DataType.DEVICE_NAME) ?? ''},
     state: ${this.state}, about to appear`);
    this.onFoldStatusChange();
    this.updateDeviceNum();
  }

  aboutToDisappear(): void {
    this.isAboutToDisappear = true;
    log.showInfo(`deviceName: ${StringUtil.getAnonymousData(this.deviceName, DataType.DEVICE_NAME) ?? ''},
     state: ${this.state}, about to disappear`);
  }

  build() {
    Stack({ alignContent: Alignment.Center }) {
      if (!DeviceHelper.isPC()) {
        Row()
          .backgroundColor(this.state === ContinuityState.CONNECTED ? this.colorModeViewData.wifiBgOnColor
            : this.colorModeViewData.wifiBgOffColor)
          .animation({
            duration: !DropDownAdapter.isDropDownShow() ? 0 : 333,
            curve: Curve.Smooth
          })
          .backgroundBrightnessInternal(this.colorModeViewData.getBrightnessOption(this.getTopRate()))
          .width(this.updatedSize)
          .height(this.updatedSize)
          .borderRadius($r('app.float.single_device_icon_bg_radius'))
          .scale({ x: this.originalSize, y: this.originalSize })
          .pointLight({
            lightSource: {
              positionX: '50%',
              positionY: '50%',
              positionZ: 100,
              intensity: this.getLightIntensity()
            },
            bloom: this.getLightBloom()
          })
      } else {
        Row()
          .backgroundColor(this.state === ContinuityState.CONNECTED ? this.colorModeViewData.wifiBgOnColor
            : this.colorModeViewData.superDeviceBgColor)
          .backgroundBrightnessInternal(this.getTopRate())
          .animation({ duration: 333, curve: Curve.Linear })
          .width(this.updatedSize)
          .height(this.updatedSize)
          .borderRadius($r('app.float.single_device_icon_bg_radius'))
          .scale({ x: this.originalSize, y: this.originalSize })
      }
      if (this.isHideDeviceIcon()) {
        Canvas(this.context2D)
          .width(this.updatedSize)
          .height(this.updatedSize)
          .borderRadius($r('app.float.single_device_icon_bg_radius'))
          .scale({ x: this.originalSize, y: this.originalSize })
          .draggable(false)
          .onReady(() => {
            if (this.animationItem !== null && (this.previousNum !== this.deviceNum ||
              this.previousUpdatedSize !== this.updatedSize.id)) {
              log.showInfo('refresh animation');
              this.animationItem.resize();
            }
            this.previousNum = this.deviceNum;
            this.previousUpdatedSize = this.updatedSize.id;

            log.showInfo('start to play the animation');
            this.canvasReady = true;
            this.loadAnimation();
          })
          .onAppear(() => {
            if (this.isAboutToDisappear) {
              log.showError('page has disappear, no need load lottie');
              return;
            }
            // 处理快进快出动效
            log.info('refresh the animation');
            if (this.animationItem !== null && this.canvasReady) {
              log.info('refreshing lottie');
              this.loadAnimation(true, this.lottieName);
            }
          })
          .onDisAppear(() => {
            lottie.destroy(this.lottieName);
            log.showInfo('cancel to play the animation');
            if (AccessibilityUtil.isAccessibilityMode()) {
              AccessibilityUtil.requestFocusForAccessibility(StringUtil.getAnonymousUniqueId(this.serviceUniqueId));
            }
          })
      } else {
        if (this.isStereo(this.extra)) {
          Image(this.getStereoRes(this.extra))
            .width($r('app.float.single_device_icon_size'))
            .height($r('app.float.single_device_icon_size'))
            .scale({ x: this.iconOriginalSize, y: this.iconOriginalSize })
            .objectFit(ImageFit.Contain)
            .draggable(false)
            .fillColor(this.state === ContinuityState.CONNECTED ?
            this.style.newIconOnColor : this.style.newIconOffColor)
        } else {
          SymbolGlyph(this.getDeviceIcon(this.deviceType) ? this.getDeviceIcon(this.deviceType) :
          $r('sys.symbol.unknown_device_fill'))
            .fontSize($r('app.float.single_device_icon_size'))
            .fontColor(this.state === ContinuityState.CONNECTED ? [this.colorModeViewData.commonIconOnColor]
              : [this.colorModeViewData.commonIconOffColor])
            .scale({ x: this.iconOriginalSize, y: this.iconOriginalSize })
            .renderingStrategy(SymbolRenderingStrategy.MULTIPLE_OPACITY)
            .draggable(false)
            .foregroundBrightness(this.colorModeViewData.getBrightnessOption(
              this.colorModeViewData.getPrimaryFgOption(this.state === ContinuityState.CONNECTED ? true : false)))
        }
      }
    }
    .key(this.deviceName)
    .onTouch(this.touchAction)
    .onClick(() => {
      this.onIconClick(this.showInfo, this.index);
    })
    .borderRadius(24)
    .focusBox({
      margin: new LengthMetrics(2, LengthUnit.VP), //  设置内边距，贴在组件内部绘制
      strokeColor: ColorMetrics.rgba(10, 89, 247), // 设置焦点框线条颜色
      strokeWidth: DeviceHelper.isPC() ? LengthMetrics.vp(2) : LengthMetrics.vp(2.5) // 设置焦点框线条宽度
    })
    .accessibilityText(this.accessText ?? '')
    .id(Constants.DEVICE_ITEM_ID + StringUtil.getAnonymousUniqueId(this.serviceUniqueId));
  }
}
