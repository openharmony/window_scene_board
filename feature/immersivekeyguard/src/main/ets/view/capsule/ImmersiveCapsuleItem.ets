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

import { AodStyleType, ImmersiveAodStyle, ImmersiveConstants, immersiveKgMgr } from '@ohos/systemuicommon';
import { ImmersiveMediaCapsule } from '@ohos/mediacontrolcomponent';
import { CapsulePositionType } from '../../common/ImmersiveConstants';
import { ImmersiveCapsuleStyle } from '../../model/data/ImmersiveCapsuleStyle';
import { ImmersiveCapsuleVm } from '../../viewmodel/ImmersiveCapsuleVm';
import { immersiveVm } from '../../viewmodel/ImmersiveVm';
import { ImmersiveAnimManager } from '../../viewmodel/viewanim/ImmersiveAnimManager';
import { ImmersiveCapsuleData } from '../../viewmodel/viewdata/ImmersiveCapsuleData';
import { ImmersiveAnimKey } from '../../common/anim/ImmersiveAnimConstants';
import { ImmersiveCommonCapsule } from './ImmersiveCommonCapsule';
import { ImmersiveCapsuleConstants as CapConst } from '../../common/constants/ImmersiveCapsuleConstants';
import { CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { BrightnessOptionUtils } from '@ohos/systemuicommon/Index';
import { SlVisualArgs, SlPositionType, CcmOption, SlAreaType } from '@ohos/screenlockcommon';
import { BaseState } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { WidgetAnimState } from '@ohos/screenlockcommon/Index';
import { immersiveStateHelper } from '../../common/helper/ImmersiveStateHelper';
import { SlCapWidgetBindState } from '../../model/data/SlCapWidgetBindState';
import { SlVisualControl } from '@ohos/screenlockcommon/src/main/ets/visual/SlVisualControl'

const TAG = 'ImmersiveCapsuleItem';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 沉浸胶囊单条目
 */
@Component
export struct ImmersiveCapsuleItem {
  /**
   * 胶囊业务管理器
   */
  private capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();

  /**
   * 沉浸动效管理器
   */
  private animMgr: ImmersiveAnimManager = immersiveVm.getImmersiveAnimMgr();

  /**
   * 胶囊类型，默认内容胶囊
   */
  private capsuleType: CapsulePositionType = CapsulePositionType.TYPE_CONTENT;

  /**
   * 胶囊UI样式
   */
  @State capsuleStyle?: ImmersiveCapsuleStyle = new ImmersiveCapsuleStyle();

  /**
   * 胶囊数据
   */
  @ObjectLink capsuleData: ImmersiveCapsuleData;

  /**
   * 是否开启辅助功能朗读模式
   */
  @StorageProp('isAccessibilityMode') isAccessibilityMode: boolean = false;

  /**
   * 胶囊动效状态
   */
  @State animState?: WidgetAnimState = BaseState.wrap(WidgetAnimState, '');

  @State innerState?: WidgetAnimState = BaseState.wrap(WidgetAnimState, ''); // 胶囊动效下一层状态

  /**
   * Aod显示样式
   */
  @State aodStyle: ImmersiveAodStyle | undefined = immersiveKgMgr.getOneMirrorState().getAodStyle(true);

  // 锁屏首页沉浸胶囊组件状态
  @State slCapsuleWidgetBindState?: SlCapWidgetBindState =
    immersiveStateHelper.getSlCapsuleWidgetBindState() as SlCapWidgetBindState;

  // 锁屏首页沉浸胶囊组件状态
  @State slCapsuleAnimState?: WidgetAnimState =
    immersiveStateHelper.getImmerseCapsuleAnimState() as WidgetAnimState;

  /**
   * 根据壁纸计算是否压暗
   */
  @Prop isDarken: boolean = false;

  @State contentBackBrightArgs?: SlVisualArgs =
    SlVisualControl.getInstance().getVisualArgs(SlPositionType.SL_CAP_FIRST_BACKGROUND);
  @State shadowBackBrightArgs?: SlVisualArgs =
    SlVisualControl.getInstance().getVisualArgs(SlPositionType.SL_CAP_SECOND_BACKGROUND);
  private enableSolid: boolean = SlVisualControl.getInstance().getEnable(CcmOption.SOLID, SlAreaType.CAPSULE);
  private enableBright: boolean = SlVisualControl.getInstance().getEnable(CcmOption.BRIGHT, SlAreaType.CAPSULE);

  private brightColor: ResourceColor = '#FF000000';

  aboutToAppear(): void {
    log.showInfo(`aboutToAppear capsuleType:${this.capsuleType}`);
    // 加载对应类型UI样式
    this.capsuleStyle = this.capsuleVm.getChildUiStyle(this.capsuleType);
    // 加载对应类型动效状态
    this.animState = this.animMgr.getCapsuleAnimState(this.capsuleType);
    this.innerState = this.animState?.getChildState(this.capsuleType);
  }

  aboutToDisappear(): void {
    log.showInfo(`aboutToDisAppear capsuleType:${this.capsuleType}`);
  }

  build() {
    if (this.capsuleData) {
      this.commonRootItemView()
    }
  }

  /**
   * 组件根布局样式
   */
  @Styles
  private rootItemStyle(): void {
    .borderRadius(this.capsuleStyle?.borderRadius)
    .width('100%')
    .hitTestBehavior(HitTestMode.Transparent)
    .height(this.capsuleStyle?.rootHeight)
    .scale(this.getItemScale())
    .opacity(this.getRootAlpha())
    .translate(this.getRootTran())
    .blur(this.getComponentBlurRadius())
    .zIndex(this.getRootZIndex())
    .onAreaChange((old, newArea) => {
      // 缓存胶囊位置
      this.animMgr.setCapsuleViewArea(this.capsuleType, newArea);
    })
  }

  /**
   * 胶囊内容
   */
  @Builder
  private itemContent(): void {
    if (this.capsuleData?.isMediaPlay()) { // 播控样式
      ImmersiveMediaCapsule({
        isAnimeComponent: this.capsuleType === CapsulePositionType.TYPE_ANIM_CONTENT,
        capHeight: this.capsuleStyle?.height,
        capWidth: this.getInnerWidth(),
        textAlpha: this.getInnerAlpha(),
        isDarken: this.isDarken,
        isEnabled: this.capsuleType === CapsulePositionType.TYPE_CONTENT
      })
    } else if (this.capsuleData) { // 其他胶囊样式
      ImmersiveCommonCapsule({
        capsuleData: this.capsuleData,
        baseTemplate: this.capsuleData?.liveBaseTemplate,
        templateTime: this.capsuleData?.templateTime,
        capsuleStyle: this.capsuleStyle,
        animState: this.innerState,
        isDarken: this.isDarken,
        isEnabled: this.capsuleType === CapsulePositionType.TYPE_CONTENT,
        isEnableSolid: this.enableSolid
      })
    }
  }

  /**
   * 组件内部内容UI
   */
  @Builder
  private innerItemView(): void {
    Stack({ alignContent: Alignment.Start }) {
      // 模糊背景
      Stack()
        .accessibilityLevel('no')
        .useEffect(this.enableBright)
        .width(this.getAnimWidth())
        .height(this.getAnimHeight())
        .borderRadius(this.getAnimRadius())

      Stack()
        .accessibilityLevel('no')
        .width(this.getAnimWidth())
        .height(this.getAnimHeight())
        .borderRadius(this.getAnimRadius())
        .backgroundColor(this.getItemViewBackgroundColor())
        .backgroundBrightnessInternal(this.getBackgroundBrightnessInternal())

      Stack()
        .accessibilityLevel('no')
        .width(this.getAnimWidth())
        .height(this.getAnimHeight())
        .borderRadius(this.getAnimRadius())
        .backgroundColor(this.getItemViewBackgroundColor())
        .visibility(this.aodStyle?.isAod ?
        Visibility.Visible : Visibility.Hidden)
      // 胶囊内容
      this.itemContent()
    }
    .accessibilityLevel(this.getAccessibilityLevel())
    .clickEffect({
      level: ClickEffectLevel.LIGHT
    })
    .clip(this.isClipItem())
    .margin(this.getContentMargin())
    .width(this.getAnimWidth())
    .height(this.getAnimHeight())
    .borderRadius(this.getAnimRadius())
    .translate(this.getAnimTran())
    .pointLight({
      illuminated: this.aodStyle?.isAod ? IlluminatedType.NONE : IlluminatedType.BORDER
    })
  }

  /**
   * 组件根布局普通UI
   */
  @Builder
  private commonRootItemView(): void {
    Stack({ alignContent: Alignment.Top }) {
      this.innerItemView()
    }
    .rootItemStyle()
  }

  private getItemViewBackgroundColor(): number | ResourceColor | undefined {
    if (this.aodStyle?.isAod) {
      if (this.isEffect()) {
        return this.aodStyle?.getStyleValue(AodStyleType.BACKGROUND_COLOR);
      } else {
        return this.aodStyle?.getStyleValue(AodStyleType.SHADE_BACKGROUND_COLOR);
      }
    }
    if (this.enableSolid) {
      if (this.isEffect()) {
        return this.contentBackBrightArgs?.getSolidColor();
      } else {
        return this.shadowBackBrightArgs?.getSolidColor();
      }
    }

    if (!this.enableBright) {
      if (this.isEffect()) {
        return this.contentBackBrightArgs?.getBrightnessColor(this.isDarken);
      } else {
        return this.shadowBackBrightArgs?.getBrightnessColor(this.isDarken);
      }
    }
    return this.brightColor;
  }

  private getBackgroundBrightnessInternal(): BrightnessOptions | undefined {
    if (this.enableSolid || !this.enableBright) {
      return undefined;
    }
    if (this.aodStyle?.isAod) {
      if (this.isEffect()) {
        return BrightnessOptionUtils.aodScreenNtfBaseboardLightOption;
      }
      return BrightnessOptionUtils.aodScreenNtfSecondBoardLightOption;
    }
    return CapConst.getCapsuleBrightEffect(this.isEffect(), this.isDarken);
  }

  private isEffect(): boolean {
    return this.capsuleType === CapsulePositionType.TYPE_CONTENT ||
      this.capsuleType === CapsulePositionType.TYPE_ANIM_CONTENT ||
      this.capsuleType === CapsulePositionType.TYPE_REMIND;
  }

  private getAccessibilityLevel(): string {
    if (this.capsuleType === CapsulePositionType.TYPE_ANIM_SHADOW ||
      this.capsuleType === CapsulePositionType.TYPE_SHADOW) {
      return 'no-hide-descendants';
    }
    return 'yes';
  }

  /**
   * 胶囊具体显示内容外间距
   *
   * @returns 外间距
   */
  private getContentMargin(): Margin | number | undefined {
    return this.capsuleStyle?.margin;
  }

  /**
   * 获取根组件透明度
   *
   * @returns 透明度
   */
  private getRootAlpha(): number | undefined {
    // 胶囊动效中，使用动效透明度
    if (this.animState?.isSceneAnimating()) {
      return this.animState?.getAlpha();
    }
    if (this.slCapsuleAnimState?.isSceneAnimating()) {
      return this.slCapsuleAnimState?.getAlpha() ?? this.slCapsuleWidgetBindState?.getAlpha();
    }
    // 绑定状态透明度
    return this.slCapsuleWidgetBindState?.getAlpha();
  }

  /**
   * 获取根组件位移
   *
   * @returns 位移
   */
  private getRootTran(): TranslateOptions | undefined {
    // 动效位移
    if (this.animState?.isSceneAnimating()) {
      return { x: this.animState?.getTranX(), y: this.animState?.getTranY() };
    }
    return undefined;
  }

  /**
   * 获取动效裁切偏移
   *
   * @returns 偏移
   */
  private getAnimTran(): TranslateOptions | undefined {
    // 动效位移，用位移替代裁切偏移
    if (this.isClipItem()) {
      let offsetX = this.animState?.getClipOffsetX() ?? 0;
      let offsetY = this.animState?.getClipOffsetY() ?? 0;
      return {
        x: offsetX,
        y: offsetY
      };
    }
    return undefined;
  }

  /**
   * 内部布局宽度
   *
   * @returns inner宽度
   */
  private getInnerWidth(): number | string {
    if (this.innerState?.isSceneAnimating()) {
      return this.innerState?.getWidth() ?? '100%';
    }
    return '100%';
  }

  /**
   * 内部透明度
   *
   * @returns 透明度
   */
  private getInnerAlpha(): number | undefined {
    if (this.innerState?.isSceneAnimating()) {
      return this.innerState?.getAlpha();
    }
    return undefined;
  }

  /**
   * 获取动态宽度
   *
   * @returns 宽度
   */
  private getAnimWidth(): number | string | undefined {
    // 动效宽度
    if (this.isClipItem()) {
      return this.animState?.getClipWidth() ?? this.capsuleStyle?.width;
    }
    return this.capsuleStyle?.width;
  }

  /**
   * 获取动态高度
   *
   * @returns 高度
   */
  private getAnimHeight(): number | string | undefined {
    // 动效高度
    if (this.isClipItem()) {
      return this.animState?.getClipHeight() ?? this.capsuleStyle?.height;
    }
    return this.capsuleStyle?.height;
  }

  /**
   * 获取动态圆角
   *
   * @returns 圆角
   */
  private getAnimRadius(): number | BorderRadiuses | undefined {
    // 动效圆角
    if (this.animState?.isSceneAnimating()) {
      return this.animState?.getBorderRadiusTL() ?? this.capsuleStyle?.borderRadius;
    }
    return this.capsuleStyle?.borderRadius;
  }

  /**
   * 是否开启条目切割
   *
   * @returns true开启切割
   */
  private isClipItem(): boolean {
    if (this.animState?.isSceneAnimating()) {
      return this.animState?.isClipEnable() ?? false;
    }
    return false;
  }

  /**
   * 获取组件模糊半径
   *
   * @returns 组件模糊半径
   */
  private getComponentBlurRadius(): number | undefined {
    if (this.animState?.isSceneAnimating()) {
      return this.animState?.getBlur();
    }
    return undefined;
  }

  /**
   * 胶囊组件缩放值
   *
   * @returns 缩放值
   */
  private getItemScale(): ScaleOptions | undefined {
    if (this.animState?.isSceneAnimating()) {
      return { x: this.animState.getScaleX(), y: this.animState.getScaleY() };
    }
    const scale = this.slCapsuleWidgetBindState?.getScale();
    if (this.slCapsuleAnimState?.isSceneAnimating()) {
      return {
        x: this.slCapsuleAnimState?.getScaleX() ?? scale,
        y: this.slCapsuleAnimState?.getScaleX() ?? scale
      };
    }
    return { x: scale, y: scale };
  }

  /**
   * 胶囊组件zIndex值
   *
   * @returns zIndex值
   */
  private getRootZIndex(): number | undefined {
    if (this.animState?.isSceneAnimating()) {
      return this.animState?.getZIndex();
    }
    return undefined;
  }
}