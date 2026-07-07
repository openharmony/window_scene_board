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
import { DomainName, LogDomain, LogHelper, TraceUtil } from '@ohos/basicutils';
import { baseStateMgr } from '@ohos/systemuiutils/src/main/ets/sysdialog/BaseStateManager';
import { DarkModeState, StateType } from '@ohos/systemuiutils/src/main/ets/sysdialog/BaseState';
import { LiveUseScene, LiveViewCommonConstants, OtherFormExtendShowType } from '../../../common/LiveConstants';
import { LiveOtherExtendData } from '../../../data/extend/LiveOtherExtendData';
import { ExtendStyle } from '../../../common/Extendstyle';
import { LiveViewExtendStyle } from '../../../data/extend/LiveViewExtendStyle';
import { immersiveKgMgr } from '../../../../immersivekeyguardcommon/manager/ImmersiveKeyguardStateManager';
import { AodStyleType, ImmersiveAodStyle } from '../../../../immersivekeyguardcommon/base/interface/ImmersiveAodStyle';
import { NotificationType } from '../../../../constants/NotificationType';
import { LiveViewData } from '../../../data/LiveViewData';
import { ImmersiveSysEventUtils } from '../../../../immersivekeyguardcommon/common/ImmersiveSysEventUtil';
import { TextEmojiHelper } from '../../../../utils/TextEmojiHelper';
import { LengthMetrics } from '@ohos.arkui.node';
import { OhterCardExtendAnimVm } from '../../vm/OhterCardExtendAnimVm';
import {
  ClickNotificationErrorCode,
  ClickNotificationMaintenance
} from '../../../../maintenance/ClickNotificationMaintenance';
import { ClickRegion } from '../../../../maintenance/StatisticsConstants';
import { LiveBaseTemplate } from '../../../data/template/LiveBaseTemplate';

const TAG = LiveViewCommonConstants.LOG_PREFIX + 'ExtendComponent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
const textEmojiHelper: TextEmojiHelper = new TextEmojiHelper();
const SMALL_FOLD_OUTER_SCREEN_IMMERSIVE_SIZE = 38;
/**
 * 三方卡片辅助区
 */
@Component
export struct ExtendComponent {
  @ObjectLink data: LiveOtherExtendData;
  @State darkModeState: DarkModeState = baseStateMgr.getBaseState(StateType.TYPE_DARK_MODE) as DarkModeState;
  @Consume notificationType: number;

  @Prop capsuleBackgroundColor: string | ResourceColor = $r('app.color.ntf_brightness_bg_color');
  @Prop capsuleForegroundColor: string | ResourceColor = '#FFFFFFF';
  @Prop isSmallFoldOuterScreen: boolean = false;
  isImmersiveLive: boolean = false;
  /**
   * 锁屏壁纸颜色状态
   */
  @Prop isLight?: boolean = undefined;
  /**
   * 是否导航
   */
  @Prop isNavigation?: boolean = false;
  /**
   * 使用系统图标规格
   */
  @Prop useSysIconSize?: boolean = undefined;
  /**
   * AOD显示样式
   */
  @State aodStyle: ImmersiveAodStyle | undefined = immersiveKgMgr.getOneMirrorState().getAodStyle(
    this.notificationType === NotificationType.TYPE_PHONE_KEYGUARD);

  private extendStyle: ExtendStyle = new LiveViewExtendStyle();

  @Prop bgBrightnessOption?: BrightnessOptions;

  @Prop foreBrightnessOption?: BrightnessOptions;

  @State otherCardExtendAnimVm: OhterCardExtendAnimVm = new OhterCardExtendAnimVm();

  private isCapsule: boolean = false;

  private baseData?: LiveViewData;

  private useScene: LiveUseScene = LiveUseScene.SCENE_LIVE_LIST;

  aboutToAppear(): void {
    this.otherCardExtendAnimVm.init(this.baseData?.hashCode ?? '', this.useScene);
  }

  aboutToDisappear(): void {
    this.otherCardExtendAnimVm.destroy();
  }

  build() {
    if (this.data && this.data?.type !== OtherFormExtendShowType.NOT_SHOW) {
      Row() {
        if (this.data?.type === OtherFormExtendShowType.NORMAL_TEXT) {
          Text(this.data?.text ?? '')
            .fontFamily('HarmonyHeiTi')
            .fontWeight(FontWeight.Regular)
            .maxFontSize(this.extendStyle.normalTextMaxFont ? this.extendStyle.normalTextMaxFont + 'vp' : undefined)
            .minFontSize(this.extendStyle.normalTextMinFont ? this.extendStyle.normalTextMinFont + 'vp' : undefined)
            .fontFeature('\"ss08\" on')
            .fontColor(this.getTextColor())
            .foregroundBrightness(this.foreBrightnessOption)
            .textAlign(TextAlign.Center)
            .maxLines(2)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .width(this.extendStyle.normalTextWidth)
            .height(this.extendStyle.normalTextHeight)
            .renderGroup(this.isRenderGroup(this.data?.text ?? ''))
            .opacity(this.getAlpha())
        } else if (this.data?.type === OtherFormExtendShowType.CAPSULE_TEXT) {
          Button({
            type: ButtonType.Capsule,
            stateEffect: true
          }) {
            Text(this.data?.text ?? '')
              .fontFamily('HarmonyHeiTi')
              .fontWeight(FontWeight.Bold)
              .maxFontSize(this.extendStyle.normalTextMaxFont ? this.extendStyle.normalTextMaxFont + 'vp' : undefined)
              .minFontSize(this.extendStyle.normalTextMinFont ? this.extendStyle.normalTextMinFont + 'vp' : undefined)
              .fontFeature('\"ss08\" on')
              .fontColor(this.getTextColor())
              .foregroundBrightness(this.foreBrightnessOption)
              .opacity(this.getButtonTextAlpha())
              .textAlign(TextAlign.Center)
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .height(this.extendStyle.capsuleButtonTextHeight)
              .margin({
                top: LengthMetrics.vp(this.extendStyle.capsuleButtonTopMargin),
                bottom: LengthMetrics.vp(this.extendStyle.capsuleButtonTopMargin),
                end: LengthMetrics.vp(this.extendStyle.capsuleButtonLeftMargin),
                start: LengthMetrics.vp(this.extendStyle.capsuleButtonLeftMargin)
              })
              .renderGroup(this.isRenderGroup(this.data?.text ?? ''))
          }
          .height(this.extendStyle.capsuleButtonHeight)
          .constraintSize({
            minWidth: this.extendStyle.capsuleButtonWidth,
            maxWidth: this.extendStyle.capsuleButtonMaxWidth,
            maxHeight: this.extendStyle.capsuleButtonHeight,
          })
          .backgroundColor(this.getButtonBgColor())
          .backgroundBrightnessInternal(this.bgBrightnessOption)
        } else if (this.data?.type === OtherFormExtendShowType.PICTURE && this.data?.pic) {
          Image(this.data?.pic)
            .objectFit(ImageFit.Contain)
            .draggable(false)
            .interpolation(ImageInterpolation.Medium)
            .width(this.isNavigation ? this.extendStyle.navExtendWidth : this.extendStyle.extendWidth)
            .height(this.isNavigation ? this.extendStyle.navExtendHeight : '100%')
            .opacity(this.getAlpha())
        } else if (this.data?.type === OtherFormExtendShowType.ICON && this.data?.pic) {
          Image(this.data?.pic)
            .objectFit(ImageFit.ScaleDown)
            .draggable(false)
            .interpolation(ImageInterpolation.Medium)
            .constraintSize(this.getIconConstraintSize())
            .opacity(this.getAlpha())
        }
      }
      .accessibilityLevel('yes')
      .accessibilityGroup(true)
      .height(this.extendStyle.extendHeight)
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .borderRadius($r('app.float.live_view_extend_border_radius'))
      .clip(true)
      .gesture(GestureGroup(GestureMode.Parallel,
        TapGesture({ count: 1 }).onAction(event => this.onExtendClick()),
        TapGesture({ count: 2 }).onAction(event => this.onExtendClick(2))
      ))
    }
  }

  private getIconConstraintSize(): ConstraintSizeOptions {
    let extendWidth = this.extendStyle.extendWidth;
    let extendHeight = this.extendStyle.extendHeight;
    if (this.isSmallFoldOuterScreen && this.isImmersiveLive) {
      extendWidth = SMALL_FOLD_OUTER_SCREEN_IMMERSIVE_SIZE;
      extendHeight = SMALL_FOLD_OUTER_SCREEN_IMMERSIVE_SIZE;
    }
    return {
      maxWidth: this.useSysIconSize ? this.extendStyle.buttonLength : extendWidth,
      maxHeight: this.useSysIconSize ? this.extendStyle.buttonLength : extendHeight
    }
  }

  private getTextColor(): ResourceColor | undefined {
    if (this.isCapsule) {
      return this.capsuleForegroundColor;
    }
    return this.aodStyle?.isAod ? this.aodStyle?.getStyleValue(AodStyleType.CAPSULE_SECONDARY_FONT_COLOR) :
      this.getMainTextFontColor(this.isLight);
  }

  private getMainTextFontColor(isLight?: boolean): ResourceColor | undefined {
    if (!this.isLight) {
      return this.extendStyle.textColor;
    }
    return isLight ? '#000000' : '#FFFFFF';
  }

  private getButtonBgColor(): ResourceColor | string | undefined {
    return this.capsuleBackgroundColor;
  }

  private onExtendClick(clickCount?: number): void {
    log.showInfo(`onExtendClick clickCount：${clickCount} onExtentClick:${this.extendStyle.onExtentClick == null}`);
    if (this.notificationType === NotificationType.TYPE_PHONE_KEYGUARD && clickCount === 2) {
      ImmersiveSysEventUtils.reportExtendClickEvent(this.data, this.baseData?.hashCode);
    }
    if (this.extendStyle.onExtentClick) {
      // ImmersiveCapsuleVm#onExtendClick 处理点击事件
      this.extendStyle.onExtentClick(this.data, clickCount);
      return;
    }

    let clickRegion = ClickRegion.SUB_AREA;
    const cardWant = (this.baseData?.template as LiveBaseTemplate)?.wantAgent;
    if (cardWant && this.data?.clickAction === cardWant) {
      clickRegion = this.useScene === LiveUseScene.SCENE_LIVE_LIST ? ClickRegion.EXTEND_AREA : ClickRegion.NTF_MAIN;
    }
    ClickNotificationMaintenance.saveInfo({
      data: this.baseData,
      clickRegion: clickRegion
    });
    log.showInfo(`${TraceUtil.CORE_METHOD_CLICK_LIVE_WIN_BUTTON} start`);
    TraceUtil.startTrace(DomainName.SYS_UI, TraceUtil.CORE_METHOD_CLICK_LIVE_WIN_BUTTON);
    if (!this.data?.clickAction) {
      log.showError('click action is invalid.');
      TraceUtil.endTrace(DomainName.SYS_UI, TraceUtil.CORE_METHOD_CLICK_LIVE_WIN_BUTTON);
      log.showInfo(`${TraceUtil.CORE_METHOD_CLICK_LIVE_WIN_BUTTON} end`);
      ClickNotificationMaintenance.reportClick(ClickNotificationErrorCode.NO_CLICK_ACTION);
      return;
    }
    this.data?.clickAction?.handleExtendClick(this.data, clickCount, this.notificationType, this.baseData?.creatorUid);
    TraceUtil.endTrace(DomainName.SYS_UI, TraceUtil.CORE_METHOD_CLICK_LIVE_WIN_BUTTON);
    log.showInfo(`${TraceUtil.CORE_METHOD_CLICK_LIVE_WIN_BUTTON} end`);
  }

  /**
   * 提亮属性与emoji同时设置时需要RenderGroup置false
   * 提亮属性与opacity(不为1)同时设置时需要RenderGroup置false，否则文本无法正常显示
   * @param text 胶囊文本
   * @returns isRenderGroup
   */
  private isRenderGroup(text: string): boolean {
    if (textEmojiHelper.isEmoji(text) || this.aodStyle?.isOneMirror || this.aodStyle?.isAod) {
      return false;
    }
    return true;
  }

  private getAlpha(): number | undefined {
    if (this.aodStyle?.isAod) {
      if (this.data.wantAgent) {
        return this.aodStyle?.getStyleValue(AodStyleType.NTF_EXTEND_VIEW_ALPHA_BUTTON);
      }
      return this.aodStyle?.getStyleValue(AodStyleType.NTF_EXTEND_VIEW_ALPHA_CONTENT);
    }

    if (this.data?.type === OtherFormExtendShowType.PICTURE || this.data?.type === OtherFormExtendShowType.ICON) {
      return this.otherCardExtendAnimVm.opacity;
    }

    return undefined;
  }

  private getButtonTextAlpha(): number | undefined {
    return this.aodStyle?.isAod ? this.aodStyle?.getStyleValue(AodStyleType.NTF_EXTEND_VIEW_ALPHA_BUTTON_TEXT) :
      undefined;
  }
}