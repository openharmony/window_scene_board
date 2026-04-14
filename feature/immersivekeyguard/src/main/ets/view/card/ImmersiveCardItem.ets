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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { immersiveVm } from '../../viewmodel/ImmersiveVm';
import { SysTypeCode } from '@ohos/systemuicommon';
import { ImmersiveState } from '@ohos/systemuicommon';
import {
  immersiveKgMgr,
  DarkModeState,
  bannerMgr
} from '@ohos/systemuicommon';
import { ImmersiveCommonCard } from './ImmersiveCommonCard';
import { ImmersiveUiExtensionComponent } from './ImmersiveUiExtensionComponent';
import { ImmersiveMediaCard } from '@ohos/mediacontrolcomponent';
import { ImmersiveNtfData } from '../../viewmodel/viewdata/ImmersiveNtfData';
import { ImmersiveAnimManager } from '../../viewmodel/viewanim/ImmersiveAnimManager';
import { ImmersiveAnimKey, ImmersiveAnimScene } from '../../common/anim/ImmersiveAnimConstants';
import { ImmersiveCapsuleItem } from '../capsule/ImmersiveCapsuleItem';
import { CapsulePositionType, CardAnimType, ImmersiveConstants } from '../../common/ImmersiveConstants';
import { ImmersiveCapsuleList } from '../../viewmodel/viewdata/ImmersiveCapsuleList';
import { ImmersiveCardStyle } from '../../model/data/ImmersiveCardStyle';
import { ImmersiveSysEventUtil, StatusParams, ToggleWay } from '../../common/ImmersiveSysEventUtil';
import {
  AodBrightnessOptionUtils,
  BrightnessOptionUtils,
  ColorModeViewData,
  ColorModeViewModel
} from '@ohos/systemuicommon/Index';
import { ImmersiveLiveAnimSceneEnum, WidgetAnimState } from '@ohos/screenlockcommon/Index';
import {
  ImmersiveCardConst,
  ImmersiveCardBackButtonParam
} from '../../common/constants/ImmersiveCardConst';
import { SlCardWidgetBindState } from '../../model/data/SlCardWidgetBindState';
import { immersiveStateHelper } from '../../common/helper/ImmersiveStateHelper';
import { AccessibilityAppName } from '@ohos/systemuicommon/src/main/ets/accessibility/AccessibilityAppName';
import {
  CcmOption,
  DisplayUtils,
  SlAreaType,
  SlPositionType,
  SlVisualArgs,
  SlVisualControl,
  WDefault
} from '@ohos/screenlockcommon';
import { LengthMetrics } from '@kit.ArkUI';
import { ResUtils } from '@ohos/windowscene';
import { SCBVisualEffectMgr } from '@ohos/componenthelper';
import { VisualEffectConstants } from '@ohos/commonconstants';

const TAG = 'ImmersiveCardItem';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);
const BACK_BTN_GRAYSCALE = [38, 38];
const IMMERSIVE_CARD_BRIGHTNESS_DISABLE: boolean = SCBVisualEffectMgr.getFeatureParam(
  VisualEffectConstants.IMMERSIVE_CARD_BRIGHTNESS_DISABLE) === 'true';
/**
 * 沉浸卡片item
 */
@Component
export struct ImmersiveCardItem {
  private itemName: string = '';
  private animMgr: ImmersiveAnimManager = immersiveVm.getImmersiveAnimMgr(); // 沉浸动效管理
  @ObjectLink mItemData: ImmersiveNtfData;
  @ObjectLink mCurShowData: ImmersiveNtfData;
  @ObjectLink animItemData: ImmersiveNtfData;
  @State immersiveState: ImmersiveState = immersiveKgMgr.getImmersiveDisplayState()
  @ObjectLink animState: WidgetAnimState;
  @State cardToggleAnim: WidgetAnimState = this.animMgr.getCardAnimState(CardAnimType.CARD_TOGGLE_TYPE);
  @Prop isFoldFullDisplay: boolean = false;
  @State cardStyle: ImmersiveCardStyle = immersiveVm.getImmersiveCardVm().getCardStyle();
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  @State bindStateCtrl: SlCardWidgetBindState | undefined =
    immersiveStateHelper.getImmerseCardBindState() as SlCardWidgetBindState;
  @State previewAlpha: number = 1;
  /**
   * 是否开启辅助功能朗读模式
   */
  @StorageProp('isAccessibilityMode') isAccessibilityMode: boolean = false;

  /**
   * 沉浸锁屏胶囊数据
   */
  @State capsuleList: ImmersiveCapsuleList = immersiveVm.getImmersiveCapsuleVm().getShowList();
  @Prop isSmallFoldOuterScreen: boolean = false;
  @State cardBackBtnAnimState: WidgetAnimState =
    immersiveVm.getImmersiveAnimMgr().getCardAnimState(CardAnimType.CARD_LIVE_BACK_BTN_TYPE);

  /** 深色模式状态
   */
  @State darkMode: DarkModeState = bannerMgr.getBannerState().darkModeState as DarkModeState;
  @State backBrightArgs?: SlVisualArgs =
    SlVisualControl.getInstance().getVisualArgs(SlPositionType.SL_IMMERSIVE_CARD_BG);
  private enableSolid: boolean = SlVisualControl.getInstance().getEnable(CcmOption.SOLID, SlAreaType.IMMERSIVE_CARD);

  private isAnimComponent: boolean = false;
  // 沉浸卡片提亮压暗去使能，背景颜色值
  private keyguardImmersiveCardDefaultColor: Resource = $r('app.color.immersive_card_default_bg_color');

  build() {
    Stack({ alignContent: Alignment.Top }) {
      AccessibilityAppName({
        name: this.mItemData?.cardData?.appName,
        isAccessibilityMode: this.isAccessibilityMode
      })
      Stack() {
        // 统一背景
        Stack()
          .width(this.getStaticWidth())
          .height(this.getStaticHeight())
          .opacity(this.getBgAlpha())
          .backgroundBrightnessInternal(this.getBgBrightnessOption())
          .backgroundColor(this.getBgColor())

        if (this.mItemData?.cardData?.liveView?.sysTypeCode === SysTypeCode.BROADCASTING_CENTER) {
          ImmersiveMediaCard({
            notifyId: this.mItemData?.cardData?.liveView?.hashCode,
            isAnimComponent: this.isAnimComponent,
            cardStyle : {
              height: this.getStaticHeight(),
              width: this.getStaticWidth(),
              opacity: this.getContentOpacity()
            },
            isFoldFullDisplay: this.isFoldFullDisplay,
            previewAlpha: this.getPreviewAlpha(),
            isSmallFoldOuterScreen: this.isSmallFoldOuterScreen,
          })
        } else if (this.mItemData && !this.mItemData?.cardData?.immersiveWant) {
          ImmersiveCommonCard({ mItemData: this.mItemData, cardData: this.mItemData?.cardData,
            cardStyle : {
              height: this.getStaticHeight(),
              width: this.getStaticWidth(),
              opacity: this.getContentOpacity(),
            },
            previewAlpha: this.getPreviewAlpha(),
            isSmallFoldOuterScreen: this.isSmallFoldOuterScreen,
          })
        } else if (this.mItemData?.cardData?.immersiveWant) {
          // 由cardVm来控制的UIExtension扩展组件, 切换动效过程中数据没清除前还是显示状态
          ImmersiveUiExtensionComponent({ mItemData: this.mItemData, cardData: this.mItemData?.cardData,
            cardStyle : {
              height: this.getStaticHeight(),
              width: this.getStaticWidth(),
              opacity: this.getContentOpacity(),
              uiExtensionTipFontScale: this.getTipFontScale(),
              uiExtensionTipLineHeight: this.getTipLineHeight(),
              uiExtensionTipBtnLineHeight: this.getTipBtnLineHeight(),
              uiExtensionTipImageVisibility: this.getTipImageVisibility(),
              uiExtensionTipBtnBottomMargin: this.getTipBtnBottomMargin(),
              uiExtensionTipTextFlexAlign: this.getTipTextFlexAlign(),
              uiExtensionTipBtnWidth: this.getTipBtnWidth(),
              uiExtensionTipBackgroundColor: this.getTipBgColor(),
            },
            previewAlpha: this.getPreviewAlpha(),
            isSmallFoldOuterScreen: this.isSmallFoldOuterScreen,
            itemName: this.itemName
          })
        }

        if (this.animItemData && !this.cardToggleAnim.isSceneAnimating(ImmersiveAnimScene.SCENE_CARD_TO_CAPSULE) &&
          !this.animState?.isSceneAnimating(ImmersiveAnimScene.SCENE_CARD_UPDATE) &&
          !this.animState?.isSceneAnimating(ImmersiveAnimScene.SCENE_CARD_TO_CAPSULE)) {
          if (this.animItemData?.cardData?.liveView?.sysTypeCode === SysTypeCode.BROADCASTING_CENTER) {
            ImmersiveMediaCard({
              notifyId: this.animItemData?.cardData?.liveView?.hashCode,
              isAnimComponent: true,
              cardStyle : {
                height: this.getStaticHeight(),
                width: this.getStaticWidth(),
                opacity: this.getContentOpacity(),
                enabled: false,
                visibility: this.getAnimCardVisibility()
              },
              isFoldFullDisplay: this.isFoldFullDisplay,
              previewAlpha: this.getPreviewAlpha(),
              isSmallFoldOuterScreen: this.isSmallFoldOuterScreen,
            })
          } else if (!this.animItemData?.cardData?.immersiveWant) {
            // UIExtension扩展组件在动效过程中不要拉起额外的动效组件
            ImmersiveCommonCard({ mItemData: this.animItemData, cardData: this.animItemData?.cardData,
              cardStyle : {
                height: this.getStaticHeight(),
                width: this.getStaticWidth(),
                opacity: this.getContentOpacity(),
                enabled: false,
                visibility: this.getAnimCardVisibility(),
              },
              previewAlpha: this.getPreviewAlpha(),
              isSmallFoldOuterScreen: this.isSmallFoldOuterScreen,
            })
          }
        }

        if (this.shouldShowAnimCapsule()) {
          ImmersiveCapsuleItem({
            capsuleType: CapsulePositionType.TYPE_ANIM_CONTENT,
            capsuleData: this.capsuleList?.getCapData(CapsulePositionType.TYPE_ANIM_CONTENT)
          })
        }

        if (this.isSmallFoldOuterScreen && this.immersiveState.isImmersive()) {
          this.buildBackButton()
        }
      }
      .clip(true)
      .height(this.getClipHeight())
      .width(this.getClipWidth())
      .translate(this.getTranslate())
      .scale(this.getScale())
      .borderRadius(this.getBorderRadius())
      .opacity(this.getAlpha())
      .gesture(GestureGroup(GestureMode.Exclusive,
        PanGesture({
          direction: PanDirection.Up
        })// 上滑进入列表态
          .onActionEnd((event: GestureEvent) => {
            if (this.isSmallFoldOuterScreen) {
              return;
            }
            log.showWarn('PanDirection.Up start card to list');
            immersiveVm.getCardEventHandle().execCardToListAnim();
            ImmersiveSysEventUtil.reportToggleStatusEvent(this.mItemData, StatusParams.IMMERSIVE, StatusParams.LIST,
              ToggleWay.UP);
          }),
        PanGesture({
          direction: PanDirection.Down
        })// 下滑进入收拢态
          .onActionEnd((event: GestureEvent) => {
            if (this.isSmallFoldOuterScreen) {
              return;
            }
            if (immersiveKgMgr.getImmersiveKeyguardState().fingerprintState.isLowPosRecognition()) {
              log.showWarn('PanDirection.Down start card to list');
              immersiveVm.getCardEventHandle().execCardToListAnim();
            } else {
              log.showWarn('PanDirection.Down start card to capsule');
              immersiveVm.getCardEventHandle().execCardToCapsuleAnim();
              ImmersiveSysEventUtil.reportToggleStatusEvent(this.mItemData, StatusParams.IMMERSIVE,
                StatusParams.CAPSULE,
                ToggleWay.DOWN);
            }
          })
      ))
      .onTouch((event?: TouchEvent) => {
        event?.stopPropagation();
      })
      .pointLight({
        illuminated: IlluminatedType.BORDER
      })
    }
    .onClick(this.isIgnoreClick() ? undefined : (event: ClickEvent) => {
      // 点击沉浸态非操作区解锁跳转到应用
      if (this.mItemData) {
        immersiveVm.getImmersiveCardVm().clickToApp(this.mItemData);
      }
    })
    .accessibilityLevel('yes')
    .id(ImmersiveConstants.IMMERSIVE_CARD_ITEM_ID)
    .visibility(this.getCardVisibility())
    .transition(TransitionEffect.asymmetric(
      TransitionEffect.IDENTITY, this.animState?.getTransition() ?? TransitionEffect.IDENTITY))
    .width(this.getRootWidth())
    .height(this.getRootHeight())
    .onAreaChange((old, newArea) => this.animMgr.setCardViewArea(ImmersiveAnimKey.IMMERSIVE_CARD_ROOT, newArea))
    .enabled(this.isResponse())
  }

  @Builder
  buildBackButton() {
    EffectComponent() {
      Stack() {
        // 外层开启模糊
        Column() {
          // 内层提亮
          Column()
            .width('100%')
            .height('100%')
            .backgroundColor(this.getBackButtonBgColor())
            .backgroundBrightnessInternal(this.getImmersiveCardBrightnessOption(
              this.cardStyle.backBtnBackgroundBrightnessOption))
        }
        .useEffect(true)
        .width(ImmersiveCardBackButtonParam.BACKGROUND_DIAMETER)
        .height(ImmersiveCardBackButtonParam.BACKGROUND_DIAMETER)


        Image($r('app.media.chevron_backward'))
          .width(ImmersiveCardBackButtonParam.ARROW_SIZE)
          .height(ImmersiveCardBackButtonParam.ARROW_SIZE)
          .fillColor(Color.White)
          .matchTextDirection(true)
          .foregroundColor(this.getBackButtonForegroundColor())
          .foregroundBrightness(this.getImmersiveCardBrightnessOption(
            this.cardStyle.backBtnForegroundBrightnessOption))

      }
      .clip(true)
      .borderRadius(ImmersiveCardBackButtonParam.BUTTON_RADIUS)
      .accessibilityLevel('yes')
      .accessibilityText(ImmersiveCardItem.getStringByContext(getContext(this), $r('app.string.psd_back_accessible')))
      .onClick(() => {
        immersiveVm.handleImmersiveBackEvent();
      })
    }.backgroundEffect({
      policy: BlurStyleActivePolicy.ALWAYS_ACTIVE,
      radius: ImmersiveCardBackButtonParam.EFFECT_RADIUS,
      brightness: ImmersiveCardBackButtonParam.EFFECT_BRIGHTNESS,
      blurOptions: { grayscale: BACK_BTN_GRAYSCALE as [number, number] }
    })
    .margin({
      top: LengthMetrics.vp(ImmersiveCardBackButtonParam.MARGIN_TOP),
      bottom: LengthMetrics.vp(ImmersiveCardBackButtonParam.MARGIN_BOTTOM),
      start: LengthMetrics.vp(ImmersiveCardBackButtonParam.MARGIN_START),
      end: LengthMetrics.vp(ImmersiveCardBackButtonParam.MARGIN_END)
    })
    .opacity(this.getBackButtonOpacity())
    .visibility(this.getBackButtonVisibility())
  }

  private getBgBrightnessOption(): BrightnessOptions | undefined {
    if (this.enableSolid) {
      return undefined;
    }
    return this.getImmersiveCardBrightnessOption(
      this.colorModeViewData.keyguardImmersiveCardOption);
  }

  private getBgColor(): ResourceColor | undefined {
    let solidColor = this.backBrightArgs?.getSolidColor(this.darkMode?.isDarkMode);
    if (this.enableSolid && solidColor) {
      return solidColor;
    }

    return this.keyguardImmersiveCardDefaultColor;
  }

  private getBackButtonBgColor(): ResourceColor | undefined {
    if (this.shouldUseDefaultImmersiveCardColor()) {
      return BrightnessOptionUtils.brightColor
    }
    return this.cardStyle?.backBtnBackgroundColor;
  }

  private getBackButtonForegroundColor(): ResourceColor | undefined {
    if (this.shouldUseDefaultImmersiveCardColor()) {
      return BrightnessOptionUtils.brightColor;
    }
    return this.cardStyle?.backBtnForegroundColor;
  }

  /**
   * 产品化定制视效调整接口，配置实况通知沉浸态是否使能提亮压暗效果
   * @param option 提亮压暗参数
   * @returns option or undefined 提亮压暗禁用返回undefined，否则返回传入提亮压暗参数
   */
  private getImmersiveCardBrightnessOption(option: BrightnessOptions | undefined): BrightnessOptions | undefined {
    return IMMERSIVE_CARD_BRIGHTNESS_DISABLE ? undefined : option;
  }

  /**
   * 实况通知沉浸态产品化定制视效调整接口，配置通知沉浸态是否使能提亮压暗效果
   * @returns boolean 是否使用默认颜色
   */
  private shouldUseDefaultImmersiveCardColor(): boolean {
    return !IMMERSIVE_CARD_BRIGHTNESS_DISABLE || !this.colorModeViewData.isBrightnessActive;
  }

  private getBackButtonOpacity(): number | undefined {
    if (this.cardBackBtnAnimState?.isSceneAnimating()) {
      return this.cardBackBtnAnimState?.getAlpha();
    }
    return WDefault.MAX_VALUE;
  }

  private getBackButtonVisibility(): Visibility {
    if (this.cardBackBtnAnimState?.isSceneAnimating()) {
      return Visibility.Visible;
    }
    return this.immersiveState.isShowCard() ? Visibility.Visible : Visibility.Hidden;
  }

  private getBgAlpha(): number | undefined {
    if (this.isSmallFoldOuterScreen) {
      return 0;
    }

    if (this.animState?.isSceneAnimating(ImmersiveConstants.IMMERSIVE_ONE_MIRROR_SCENE)) {
      return this.animState.getAlpha() ?? 1;
    }

    if (!this.animState?.isSceneAnimating()) {
      return this.bindStateCtrl?.getBgAlpha() ?? 1;
    }
    // 胶囊动效中，使用动效透明度
    return this.animState?.getAlpha();
  }

  private getPreviewAlpha(): number {
    if (this.animState.isSceneAnimating(ImmersiveConstants.IMMERSIVE_ONE_MIRROR_SCENE)) {
      return this.animState.getLightUpEffect() ?? 1;
    }
    return this.bindStateCtrl?.getPreviewAlpha() ?? 1;
  }

  private isResponse(): boolean {
    if (!this.isValidData()) {
      return false;
    }
    if (this.animState.isSceneAnimating(ImmersiveAnimScene.SCENE_CARD_TO_CAPSULE) ||
      this.animState.isSceneAnimating(ImmersiveAnimScene.SCENE_CARD_TO_LIST)) {
      return false;
    }
    return true;
  }

  private getContentOpacity(): number | undefined {
    if (!this.animState?.isSceneAnimating()) {
      return undefined;
    }
    // 胶囊动效中，使用动效透明度
    return this.animState?.getAlpha() ?? WDefault.MAX_VALUE;
  }

  private shouldShowAnimCapsule(): boolean | undefined {
    return this.animState?.isSceneAnimating(ImmersiveAnimScene.SCENE_CAPSULE_TO_CARD);
  }

  private getCardVisibility(): Visibility {
    if (!this.isValidData()) {
      return Visibility.Hidden;
    }
    // 卡片动效中，保持可见
    if (this.animState?.isSceneAnimating(ImmersiveAnimScene.SCENE_CARD_TO_LIST)) {
      return Visibility.Visible;
    }
    if (this.animState?.isSceneAnimating(ImmersiveAnimScene.SCENE_CARD_TO_CAPSULE)) {
      return Visibility.Visible;
    }
    if (this.animState?.isSceneAnimating(ImmersiveAnimScene.SCENE_CAPSULE_TO_CARD)) {
      return Visibility.Visible;
    }
    if (this.animState?.isSceneAnimating(ImmersiveLiveAnimSceneEnum.SCENE_LIVE_LIST_IMME_CARD_TRANSFORM)) {
      return Visibility.Visible;
    }
    if (this.animState?.isSceneAnimating(ImmersiveLiveAnimSceneEnum.SCENE_LIVE_CAPSULE_IMME_CARD_TRANSFORM)) {
      return Visibility.Visible;
    }
    return this.immersiveState.isShowCard() && this.mItemData ? Visibility.Visible : Visibility.Hidden;
  }

  private getAnimCardVisibility(): Visibility {
    if (this.animState?.isSceneAnimating(ImmersiveAnimScene.SCENE_CARD_TO_LIST) ||
    this.animState?.isSceneAnimating(ImmersiveAnimScene.SCENE_CARD_TO_CAPSULE)) {
      return Visibility.Visible;
    }
    if (this.animState?.isSceneAnimating(ImmersiveLiveAnimSceneEnum.SCENE_LIVE_LIST_IMME_CARD_TRANSFORM)) {
      return Visibility.Visible;
    }
    if (this.animState?.isSceneAnimating(ImmersiveLiveAnimSceneEnum.SCENE_LIVE_CAPSULE_IMME_CARD_TRANSFORM)) {
      return Visibility.Visible;
    }
    return Visibility.Hidden;
  }

  private getStaticHeight(): number | string {
    if (!this.isValidData()) {
      return '100%';
    }
    if (this.animState?.isSceneAnimating()) {
      return this.animState?.getHeight() ?? '100%';
    }
    return '100%';
  }

  private getStaticWidth(): number | string {
    if (!this.isValidData()) {
      return '100%';
    }
    if (this.animState?.isSceneAnimating()) {
      return this.animState?.getWidth() ?? '100%';
    }
    return '100%';
  }

  private getClipHeight(): number | string {
    if (!this.isValidData()) {
      return '100%';
    }
    if (this.animState?.isSceneAnimating()) {
      return this.animState?.getClipHeight() ?? '100%';
    }
    return '100%';
  }

  private getClipWidth(): number | string | undefined {
    if (!this.isValidData()) {
      return '100%';
    }
    if (this.animState?.isSceneAnimating()) {
      return this.animState?.getClipWidth() ?? '100%';
    }
    return '100%';
  }

  private getTranslate(): TranslateOptions | undefined {
    if (!this.isValidData()) {
      return undefined;
    }
    if (this.animState?.isSceneAnimating()) {
      return { x: this.animState?.getTranX(), y: this.animState?.getTranY() };
    }
    return undefined;
  }

  private getScale(): ScaleOptions | undefined {
    if (!this.isValidData()) {
      return undefined;
    }
    if (this.animState?.isSceneAnimating() && this.animState?.getScaleX() != undefined &&
      this.animState?.getScaleY() != undefined) {
      return { x: this.animState.getScaleX(), y: this.animState.getScaleY() };
    }
    if (this.bindStateCtrl?.getScale()) {
      return { x: this.bindStateCtrl?.getScale(), y: this.bindStateCtrl?.getScale() };
    }
    return undefined;
  }

  private getAlpha(): number | undefined {
    if (!this.isValidData()) {
      return WDefault.MAX_VALUE;
    }
    if (this.bindStateCtrl?.getAlpha() !== undefined ||
      this.animState.isSceneAnimating(ImmersiveConstants.IMMERSIVE_ONE_MIRROR_SCENE)) {
      return this.bindStateCtrl?.getAlpha();
    }
    return this.animState?.getAlpha() ?? WDefault.MAX_VALUE;
  }

  private getBorderRadius(): number {
    let defaultRadius = ImmersiveCardConst.CARD_RADIUS;
    if (!this.isValidData()) {
      return defaultRadius;
    }
    if (this.isSmallFoldOuterScreen) {
      return ImmersiveCardConst.CARD_RADIUS_SMALL_FOLD;
    }
    if (this.animState?.isSceneAnimating()) {
      return this.animState?.getBorderRadiusTL() ?? defaultRadius;
    }
    return defaultRadius;
  }

  private getRootWidth(): number | string {
    return this.isGridLayout() ? this.cardStyle.widescreenWidth as number : '100%';
  }

  private getRootHeight(): number | string {
    return this.isGridLayout() ? this.cardStyle.widescreenHeight as number : '100%';
  }

  private isGridLayout(): boolean {
    return this.isFoldExpand() || DeviceHelper.isPad();
  }

  private isFoldExpand(): boolean {
    return this.isFoldFullDisplay && !DeviceHelper.isSmallFoldProduct();
  }

  private getTipFontScale(): number {
    return this.cardStyle.uiExtensionTipFontScale ?? 1;
  }

  private getTipLineHeight(): string | Resource {
    return this.cardStyle.uiExtensionTipLineHeight ?? $r('app.float.immersive_location_font_line_height');
  }

  private getTipBtnLineHeight(): string | Resource {
    return this.cardStyle.uiExtensionTipBtnLineHeight ?? $r('app.float.immersive_authorize_line_height');
  }

  private getTipImageVisibility(): boolean {
    // undefined转换成boolean
    return !!this.cardStyle.uiExtensionTipImageVisibility;
  }

  private static getStringByContext(context: Context, res: Resource) {
    const rsMgr = context?.resourceManager;
    if (rsMgr) {
      try {
        return rsMgr.getStringSync(res.id);
      } catch (err) {
        log.error('getStringByContext: GetStringSync error');
        return undefined;
      }
    } else {
      log.showWarn('rsMgr is none.');
      return undefined;
    }
  }

  private getTipBtnBottomMargin(): number {
    return this.cardStyle.uiExtensionTipBtnBottomMargin ??
    ResUtils.getNumber($r('app.float.immersive_location_info_margin_bottom'));
  }

  private getTipTextFlexAlign(): FlexAlign {
    return this.cardStyle.uiExtensionTipTextFlexAlign ?? FlexAlign.Center;
  }

  private getTipBtnWidth(): Length {
    return this.cardStyle.uiExtensionTipBtnWidth ??
      `calc(100% - ${ResUtils.getNumber($r('app.float.immersive_authorize_padding'))}vp)`;
  }

  private getTipBgColor(): Resource | undefined {
    return this.cardStyle.uiExtensionTipBackgroundColor ?? undefined;
  }

  private isIgnoreClick(): boolean {
    if (!this.isValidData()) {
      return true;
    }
    return this.isSmallFoldOuterScreen &&
      this.mItemData?.cardData?.liveView?.sysTypeCode !== SysTypeCode.BROADCASTING_CENTER;
  }

  private isValidData(): boolean {
    return this.mItemData?.hashCode === this.mCurShowData?.hashCode;
  }
}
