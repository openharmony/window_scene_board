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

import TextCapsule from './TextCapsule';
import TimerCapsule from './TimerCapsule';
import ProgressCapsule from './ProgressCapsule';
import { CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { CapsuleShowType, CapsuleType, SysTypeCode } from '../../common/LiveConstants';
import { LiveCapsuleData } from '../../data/capsule/LiveCapsuleData';
import { LiveProgressData } from '../../data/extend/LiveProgressData';
import { LiveTimerData } from '../../data/extend/LiveTimerData';
import { LiveViewCapsuleStyle } from '../../common/LiveViewCapsuleStyle';
import { CapsuleAnimStyle } from '../../info/capsule/CapsuleAnimStyle';
import { CapsuleListState } from '../../info/capsule/CapsuleListState';
import { capsuleStateMgr } from '../../CapsuleManager';
import { ComponentAnimState } from '../../../base/anim/ComponentAnimState';
import { AnimValue, PropertyType } from '../../../base/anim/AnimConstants';
import { BannerPanelTypeState } from '../../../banner/common/info/BannerState';
import { bannerMgr } from '../../../banner/phone/BannerManager';
import { ColorUtil } from '../../../utils/ColorUtil';
import { LengthMetrics } from '@ohos.arkui.node';
import { LiveViewData } from '../../data/LiveViewData';
import ScreenRecordCapsule from './ScreenRecordCapsule';
import { AccessibilityAppName } from '../../../accessibility/AccessibilityAppName';
import { LiveAccessibilityUtil } from '../../common/liveAccessibilityUtil';
import { immersiveKgMgr } from '../../../immersivekeyguardcommon/manager/ImmersiveKeyguardStateManager';
import { DeviceHelper } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';

const TAG = 'RootCapsule';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
const isAodOnOpacity: number = 0.4;

/**
 * 胶囊列表item根布局
 */
@Component
export default struct RootCapsule {
  private showProgressWaveAnim: boolean = false;
  private marqueeEnabled: boolean = false;
  private touchEvent: (event?: TouchEvent) => void = () => {};

  /**
   * 实况数据
   */
  @State liveViewData: LiveViewData = new LiveViewData();

  /**
   * 胶囊数据
   */
  @ObjectLink capsuleData: LiveCapsuleData;
  /**
   * 胶囊列表状态
   */
  @State capsuleListState: CapsuleListState = capsuleStateMgr.getCapsuleState();
  /**
   * 动效胶囊特殊样式
   */
  @State animStyle: CapsuleAnimStyle = new CapsuleAnimStyle();
  /**
   * 胶囊动效管理
   */
  @State capsuleAnimState: ComponentAnimState = new ComponentAnimState(TAG);
  /**
   * 胶囊是否动效占位
   */
  @Prop @Watch('onChangeCapsulePlace') isCapsulePlace: boolean = false;
  /**
   * 胶囊动效占位宽度
   */
  @State animPlaceWidth?: number = undefined;
  /**
   * 是否开启辅助功能朗读模式
   */
  @StorageProp('isAccessibilityMode') isAccessibilityMode: boolean = false;
  /**
   * 是否进入锁屏
   */
  @Prop isLockScreen: boolean = true;

  @Styles capsuleStyles() {
    .clip(this.capsuleAnimState.isAnimating)
    .scale(this.getCapsuleScale())
    .borderRadius(this.getBorderRadius())
    .backgroundColor(this.getBackgroundColor())
    .width(this.getCapsuleWidth())
    .height(this.getCapsuleHeight())
    .opacity(this.getCapsuleAlpha())
    .translate(this.getCapsuleTranslate())
    .zIndex(this.getCapsuleZIndex())
    .margin({
      start: LengthMetrics.vp(this.getMarginLeft()),
    })
  }

  @State bannerPanelType: BannerPanelTypeState = bannerMgr.getBannerState().bannerPanelType;

  aboutToAppear(): void {
    log.showInfo('aboutToAppear is normal list display:' + this.marqueeEnabled?.toString());
  }

  aboutToDisappear(): void {
    log.showInfo('aboutToDisappear is normal list display:' + this.marqueeEnabled?.toString());
  }

  @Builder
  buildContentCapsule() {
    Stack() {
      AccessibilityAppName({
        name: LiveAccessibilityUtil.getAccessibilityAppName(this.liveViewData),
        isAccessibilityMode: this.isAccessibilityMode
      })
      if (this.capsuleData?.isDataType(CapsuleType.TYPE_TEXT)) {
        TextCapsule({
          data: this.capsuleData,
          marqueeEnabled: this.isMarqueeEnabled(),
          textOpacity: this.getCapsuleTextOpacity(),
          iconOpacity: this.getCapsuleIconOpacity(),
          fontColor: this.getFontColor(),
          isAnimation: this.capsuleAnimState.isAnimating,
          shouldHideContent: this.checkShouldHideContent(),
        });
      } else if (this.capsuleData?.isDataType(CapsuleType.TYPE_TIMER)) {
        if (this.capsuleData.typeCode === SysTypeCode.SCREEN_RECORDING) { // 录屏胶囊布局区别于其他计时器胶囊
          ScreenRecordCapsule({
            liveViewData: this.liveViewData ?? new LiveViewData(),
            capsuleData: this.capsuleData,
            marqueeEnabled: this.isMarqueeEnabled(),
            timeData: this.capsuleData?.typeData as LiveTimerData,
            textOpacity: this.getCapsuleTextOpacity(),
            iconOpacity: this.getCapsuleIconOpacity(),
            fontColor: this.getFontColor(),
            touchEvent: this.touchEvent,
            isAnimation: this.capsuleAnimState.isAnimating,
            shouldHideContent: this.checkShouldHideContent(),
            isLockScreen: this.isLockScreen,
          });
        } else {
          TimerCapsule({
            data: this.capsuleData,
            marqueeEnabled: this.isMarqueeEnabled(),
            timeData: this.capsuleData?.typeData as LiveTimerData,
            textOpacity: this.getCapsuleTextOpacity(),
            iconOpacity: this.getCapsuleIconOpacity(),
            fontColor: this.getFontColor(),
            isAnimation: this.capsuleAnimState.isAnimating,
            shouldHideContent: this.checkShouldHideContent(),
            isLockScreen: this.isLockScreen,
          });
        }
      } else if (this.capsuleData?.isDataType(CapsuleType.TYPE_PROGRESS)) {
        ProgressCapsule({
          data: this.capsuleData,
          typeData: this.capsuleData?.typeData as LiveProgressData,
          marqueeEnabled: this.isMarqueeEnabled(),
          capsuleWidth: this.getCapsuleWidth(),
          showProgressWaveAnim: this.showProgressWaveAnim,
          textOpacity: this.getCapsuleTextOpacity(),
          iconOpacity: this.getCapsuleIconOpacity(),
          fontColor: this.getFontColor(),
          isAnimation: this.capsuleAnimState.isAnimating,
          shouldHideContent: this.checkShouldHideContent(),
        });
      }
    }
    .capsuleStyles()
  }

  build() {
    if (this.capsuleData) {
      if (this.isTypeShowContent()) { // 胶囊显示内容
        this.buildContentCapsule()
      } else if (this.isTypeShowShadow()) { // 胶囊显示阴影
        Row()
          .backgroundColor(this.capsuleListState.getShadowCapsuleBgColor())
          .zIndex(-1)
          .clip(true)
          .borderRadius(this.getBorderRadius())
          .width(this.getCapsuleWidth() + (0))
          .height(this.getCapsuleHeight())
          .translate(this.getCapsuleTranslate())
          .scale(this.getCapsuleScale())
          .opacity(this.getCapsuleAlpha())
          .margin({ start : LengthMetrics.vp(this.getMarginLeft()) })

      }
    }
  }

  private checkShouldHideContent(): boolean {
    if (DeviceHelper.isFoldExpandedOrHalf()) {
      return false;
    }
    if (!this.isLockScreen) {
      return false;
    }
    return this.liveViewData?.isHideContent;
  }

  private getFontColor(): string {
    return ColorUtil.getContrastColor(
      this.capsuleData?.backgroundColor ?? LiveViewCapsuleStyle.CAPSULE_DEFAULT_BG_COLOR,
      LiveViewCapsuleStyle.CAPSULE_TEXT_COLOR);
  }

  private getCapsuleTranslate(): TranslateOptions {
    if (this.capsuleAnimState.isAnimating) {
      return {
        x: this.capsuleAnimState.getPropertyValue(PropertyType.TRAN_X),
        y: this.capsuleAnimState.getPropertyValue(PropertyType.TRAN_Y),
      }
    }
    return {
      x: AnimValue.VALUE_MIN,
      y: AnimValue.VALUE_MIN
    }
  }

  private getBorderRadius(): number {
    return this.capsuleAnimState.getPropertyValue(PropertyType.BORDER_RADIUS_TL) ?? LiveViewCapsuleStyle.CAPSULE_RADIUS;
  }

  private getCapsuleScale(): ScaleOptions {
    if (this.capsuleAnimState.isAnimating) {
      return {
        x: this.capsuleAnimState.getPropertyValue(PropertyType.SCALE_X),
        y: this.capsuleAnimState.getPropertyValue(PropertyType.SCALE_Y),
        centerX: '50%',
        centerY: '50%'
      }
    }
    return {
      x: AnimValue.VALUE_MAX,
      y: AnimValue.VALUE_MAX
    }
  }

  /**
   * 胶囊透明度
   *
   * @returns 透明度
   */
  private getCapsuleAlpha(): number {
    let animAlpha = this.capsuleAnimState.getPropertyValue(PropertyType.ALPHA);
    if (CommonUtils.isNumber(animAlpha)) {
      return animAlpha as number;
    }
    // 默认可见
    return AnimValue.VALUE_MAX;
  }

  /**
   * 获取胶囊宽度
   *
   * @returns 胶囊宽度，vp
   */
  private getCapsuleWidth(): number {
    // 胶囊宽度，优先使用动效宽度
    let animWidth = this.capsuleAnimState.getPropertyValue(PropertyType.WIDTH);
    if (CommonUtils.isNumber(animWidth)) {
      return animWidth as number;
    }
    // 胶囊动效占位，使用动效初始宽度
    if (this.animPlaceWidth) {
      log.showInfo('use animPlaceWidth: ' + this.animPlaceWidth);
      return this.animPlaceWidth;
    }
    return this.capsuleListState?.getCapsuleWidth() ?? LiveViewCapsuleStyle.CAPSULE_BORDER_WIDTH;
  }

  /**
   * 获取胶囊高度
   *
   * @returns 胶囊高度
   */
  private getCapsuleHeight(): number {
    // 胶囊宽度，优先使用动效宽度
    let animHeight = this.capsuleAnimState.getPropertyValue(PropertyType.HEIGHT);
    if (CommonUtils.isNumber(animHeight)) {
      return animHeight as number;
    }
    return this.capsuleListState.capsuleHeight;
  }

  /**
   * 获取左侧外边距
   *
   * @param isTop 是否为顶部胶囊
   * @returns 左侧外边距
   */
  private getMarginLeft(): number | undefined {
    // 胶囊间距，优先使用动效间距
    if (this.capsuleAnimState.isAnimating) {
      let animMargin = this.capsuleAnimState.getPropertyValue(PropertyType.MARGIN_LEFT);
      if (CommonUtils.isNumber(animMargin)) {
        return animMargin as number;
      }
    }
    const isShadow = this.getShowType() === CapsuleShowType.SHADOW;
    return isShadow ? LiveViewCapsuleStyle.CAPSULE_SHADOW_LEFT_MARGIN : undefined;
  }

  /**
   * 获取胶囊文本透明度
   *
   * @returns 胶囊文本透明度
   */
  private getCapsuleTextOpacity(): number | undefined {
    // 胶囊文本透明度，优先使用动效宽度
    if (this.capsuleAnimState.isAnimating) {
      let animTextAlpha = this.capsuleAnimState.getPropertyValue(PropertyType.TEXT_ALPHA);
      if (CommonUtils.isNumber(animTextAlpha)) {
        return animTextAlpha as number;
      }
    }
    return undefined;
  }

  /**
   * 获取胶囊图标透明度
   *
   * @returns 胶囊文本透明度
   */
  private getCapsuleIconOpacity(): number | undefined {
    // 胶囊文本透明度，优先使用动效宽度
    if (this.capsuleAnimState.isAnimating) {
      let animIconAlpha = this.capsuleAnimState.getPropertyValue(PropertyType.ICON_ALPHA);
      if (CommonUtils.isNumber(animIconAlpha)) {
        return animIconAlpha as number;
      }
    }
    return undefined;
  }

  private getCapsuleZIndex(): number | undefined {
    if (this.capsuleAnimState.isAnimating) {
      let animZIndex = this.capsuleAnimState.getPropertyValue(PropertyType.INDEX);
      if (CommonUtils.isNumber(animZIndex)) {
        return animZIndex as number;
      }
    }
    const showType = this.getShowType();
    if (showType === CapsuleShowType.TOP) {
      return 1;
    }
    if (showType === CapsuleShowType.SHADOW) {
      return -1;
    }
    return undefined;
  }

  /**
   * 类型是否显示胶囊内容
   *
   * @returns true 显示胶囊内容
   */
  private isTypeShowContent(): boolean {
    // 动效胶囊样式优先判断
    if (this.animStyle?.hasCapsuleShowType()) {
      return this.animStyle?.isCapsuleShowContent() ?? false;
    }

    // 胶囊数据真实显示类型
    return this.capsuleData?.isCapsuleShowContent() ?? false;
  }

  /**
   * 类型是否显示胶囊阴影
   *
   * @returns true 显示胶囊阴影
   */
  private isTypeShowShadow(): boolean {
    // 动效胶囊样式优先判断
    if (this.animStyle?.hasCapsuleShowType()) {
      return this.animStyle?.isCapsuleShowShadow() ?? false;
    }

    // 胶囊数据真实显示类型
    return this.capsuleData?.isCapsuleShowShadow() ?? false;
  }

  /**
   * 获取胶囊背景颜色
   *
   * @returns 背景颜色
   */
  private getBackgroundColor(): string {
    // 动效胶囊优先
    if (this.animStyle?.backgroundColor) {
      return this.animStyle?.backgroundColor as string;
    }
    return this.capsuleData?.backgroundColor ?? LiveViewCapsuleStyle.CAPSULE_DEFAULT_BG_COLOR;
  }

  private isMarqueeEnabled(): boolean {
    if (!this.marqueeEnabled) {
      return false;
    }
    if (this.bannerPanelType.hasPanelCapsuleList()) {
      return false;
    }
    if (this.capsuleListState.capsuleHideScene !== 0) {
      return false;
    }
    return true;
  }

  private getShowType(): CapsuleShowType {
    if (this.animStyle.hasCapsuleShowType()) {
      return this.animStyle.capsuleShowType!;
    }
    return this.capsuleData?.showType ?? CapsuleShowType.NONE;
  }

  private onChangeCapsulePlace(): void {
    log.showInfo('onChangeCapsulePlace: ' + this.isCapsulePlace)
    if (!this.isCapsulePlace) {
      this.animPlaceWidth = undefined;
      return;
    }
    if (!this.animPlaceWidth) {
      this.animPlaceWidth = this.capsuleListState?.getCapsuleWidth() ?? LiveViewCapsuleStyle.CAPSULE_BORDER_WIDTH;
    }
  }
}