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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { DeviceHelper, EvtBus } from '@ohos/frameworkwrapper';
import { NotificationAnimationParas } from '../../common/NotificationAnimationParas';
import { NotificationUtils } from '../../common/NotificationUtils';
import { NotificationEntry } from '../../model/NotificationEntry';
import I18n from '@ohos.i18n';
import { LengthMetrics } from '@ohos.arkui.node';
import { NtfAnimationConsts } from '../../common/NtfAnimationConsts';
import { NotificationConstants } from '../../common/NotificationConstants';
import { ntfViewConfigManager } from '../../vm/config/NtfViewConfigManager';
import { NtfListContentConfig } from '../../vm/config/NtfViewConfig';
import { NtfColorModeVM } from '../../vm/NtfColorModeVM';
import { ExtraNtfCollapsedAnimation } from '../../animation/ExtraNtfCollapsedAnimation';
import { ExtraNtfCollapseEvent } from '../../common/event/NotificationEvent';
import { NotificationGroupExpandAnimation } from '../../animation/NotificationGroupExpandAnimation';
import { AccessibilityUtil } from '@ohos/systemuicommon';

const TAG = 'NotificationExtraHeader';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

const HEADER_CONTENT_OPACITY = 0.9;
const BUTTON_ENABLE_OPACITY = 0.8;

/**
 * 更多通知头
 *
 * @since 2022-12-19
 */
@Component
export struct NotificationExtraHeader {
  @Consume isExtraNtfsCollapsed: boolean;
  @Consume extraNtfList?: Array<NotificationEntry>;
  @StorageLink('isLandscape') isLandscape: boolean = false;
  @ObjectLink ntfAniParameters: NotificationAnimationParas;

  /**
   * 通知展开状态
   */
  @Link isExtraNtfsCollapseStatusChanging: boolean;
  /**
   * 空白通知高度
   */
  @Link transparentCardHeight: number;

  private listContentConfig: NtfListContentConfig = ntfViewConfigManager.getListContentConfig();

  @State colorModeVM: NtfColorModeVM | undefined = undefined;
  /**
   * 更对通知折叠收起动效管理类
   */
  private extraNtfCollapsedAnimation: ExtraNtfCollapsedAnimation | undefined = undefined;
  /**
   * 更多通知动效参数
   */
  @Link extraNtfAnimationArray: TransitionEffect[];
  /**
   * 主通知列表是否有通知
   */
  @Prop hasMainNtf: boolean;
  /**
   * 更多通知折叠态实体
   */
  @Link extraBrief: NotificationEntry | undefined;
  /**
   * 是否在折叠状态下重新创建卡片
   */
  @Link isCreatedExtraBriefWhenCollapsed: boolean;

  calExtraNtfVisibleCount?: () => number;

  hideMoreNtfActionButtons?: (isExtraNtfsCollapsed: boolean) => void;
  aboutToAppear() {
    log.showInfo(`aboutToAppear isShowNtfExtraHeader ${(this.extraNtfList?.length ?? 0) > 1}`);
  }

  aboutToDisappear() {
    log.showInfo(`aboutToDisappear`);
  }

  build() {
    Row() {
      this.MoreNtfText()// 更多通知
      Blank()
        .height($r('app.float.ntf_extra_button_line_height'))
      Row() {
        this.CollapsedButton() // 展开/收起按钮
      }
      .id(NotificationConstants.NTF_CENTER_EXTRA_HEADER_BUTTON_COMP_ID)
      .height($r('app.float.ntf_extra_button_line_height'))
      .constraintSize({ minWidth: $r('app.float.ntf_extra_button_width') })
      .borderRadius($r('app.float.ntf_extra_button_radius'))
      .backgroundColor(DeviceHelper.isPC() ? $r('app.color.ntf_pc_extra_button_color') :
        this.colorModeVM?.themeExtraHeaderButtonBgColor)
      .backgroundBrightnessInternal(this.colorModeVM?.themeExtraHeaderButtonBgOptions)
      .visibility((this.extraNtfList && (this.extraNtfList.length ?? 0) > 1) ?
      Visibility.Visible : Visibility.None)
      .onClick(this.changeCollapseStatus)
      .margin({ end: DeviceHelper.isPC() ? LengthMetrics.vp(8) : LengthMetrics.vp(12) })
      .accessibilityRole(AccessibilityRoleType.BUTTON)
    }
    .accessibilityLevel('no')
    .alignItems(VerticalAlign.Bottom)
    .width('100%')
    .height(this.hasMainNtf ? $r('app.float.ntf_extra_height') : $r('app.float.ntf_extra_button_line_height'))
    .translate({
      y: NotificationUtils.getNtfItemTransY(this.ntfAniParameters)
    })
    .opacity(this.getOpacity())
    .scale({
      x: NotificationUtils.getNtfItemScale(this.ntfAniParameters),
      y: NotificationUtils.getNtfItemScale(this.ntfAniParameters) })
    .rotate({
      x: 1,
      y: 0,
      z: 0,
      centerX: '50%',
      centerY: '100%',
      angle: NotificationUtils.getNtfItemRotateAngle(this.ntfAniParameters)
    })
    .onClick(()=> {
      return; //更多通知区域不支持点击收起通知中心
    })
  }

  /**
   * 根据第一个更多通知卡片(NTF)的透明度值计算更多通知头(Header)透明度值，按照 Ntf 100%~thr 对应 Header 100%~0%
   * 即：Ntf = 100% 时，Header = 100%; Ntf = thr时，Header = 0%， Ntf (thr,100) 时，Header 按比例取值
   * @returns
   */
  private getOpacity(): number {
    const thr = 0.712;
    const firstMoreNtfOpacity = NotificationUtils.getNtfItemOpacity(this.ntfAniParameters);
    const opacity = Math.max((firstMoreNtfOpacity - thr) / (1 - thr), 0);
    log.showInfo('calculate opacity by %{public}d', firstMoreNtfOpacity);
    return opacity;
  }

  private changeCollapseStatus = () => {
    // 不透明到达阈值时不执行展开收起
    const opa = this.getOpacity();
    if (opa <= BUTTON_ENABLE_OPACITY) {
      log.showWarn('ChangeCollapsedStatus. origin: %{public}d, opa: %{public}d',
        this.ntfAniParameters.clearAnimOpacity, opa);
      return;
    }

    if (this.extraNtfList === undefined || this.extraNtfList.length <= 1) {
      log.showWarn('ChangeCollapsedStatus len: %{public}d', this.extraNtfList?.length);
      return;
    }

    const beforeChangeCollapseStatusTime = this.beforeChangeCollapseStatus();
    if (beforeChangeCollapseStatusTime > 0) {
      setTimeout(this.doChangeCollapseStatus, beforeChangeCollapseStatusTime);
    } else {
      this.doChangeCollapseStatus();
    }
  }

  private beforeChangeCollapseStatus(): number {
    if (this.isExtraNtfsCollapsed) {
      return 0;
    }

    // 更多通知为2时会有跳变，此处特殊处理
    if (this.extraNtfList && this.extraNtfList.length > 2) {
      this.transparentCardHeight = NotificationConstants.TRANSPARENT_CARD_HEIGHT_WHEN_COLLAPSED;
    }
    // 发送更多通知折叠事件
    EvtBus.post(ExtraNtfCollapseEvent, new ExtraNtfCollapseEvent());

    let delay = 0;
    if (this.extraNtfList?.some(it => it.isGroup && it.isItemExpanded)) {
      delay = NotificationGroupExpandAnimation.duration;
    } else if (this.extraNtfList?.some(it => this.checkIsNtfExpanded(it))) {
      delay = 250;
    }

    this.extraNtfList?.forEach(it => it.resetItemExpandState());
    return delay;
  }

  private checkIsNtfExpanded(entry: NotificationEntry): boolean {
    return entry.isItemSwipeExpand || Boolean(entry.getFirstChildEntry()?.isItemSwipeExpand);
  }

  private doChangeCollapseStatus = (): void => {
    if (this.isExtraNtfsCollapsed) {
      AccessibilityUtil.sendAccessibilityByResource($r('app.string.cc_accessibility_str_ntf_swipe_left_text'))
    } else {
      AccessibilityUtil.sendAccessibilityByResource($r('app.string.cc_accessibility_str_ntf_swipe_right_text'))
    }
    AccessibilityUtil.requestFocusAccessibility(NotificationConstants.NTF_CENTER_EXTRA_HEADER_BUTTON_COMP_ID);
    this.isCreatedExtraBriefWhenCollapsed = this.isExtraNtfsCollapsed;
    this.extraBrief = this.extraNtfList?.[0];
    if (this.isExtraNtfsCollapsed && this.calExtraNtfVisibleCount) {
      this.extraNtfCollapsedAnimation?.updateExtraNtfVisibleCount(this.calExtraNtfVisibleCount());
    }
    if (this.hideMoreNtfActionButtons) {
      this.hideMoreNtfActionButtons(!this.isExtraNtfsCollapsed);
    }
    this.extraNtfAnimationArray = this.extraNtfCollapsedAnimation?.getExtraNtfAnimationArray() ?? [];
    this.isExtraNtfsCollapseStatusChanging = true;
    animateTo({
      delay: this.isExtraNtfsCollapsed ? 0 : this.extraNtfCollapsedAnimation?.getFirstExtraNtfDelayTime(),
      duration: this.extraNtfCollapsedAnimation?.extraNtfCollapsedDuration,
      curve: NtfAnimationConsts.GROUP_ITEM_EXPAND_CURVE,
      onFinish: () => {
        this.changeTransparentCardHeight();
        this.isExtraNtfsCollapseStatusChanging = false;
      }
    }, () => {
      this.isExtraNtfsCollapsed = !this.isExtraNtfsCollapsed;
      log.showInfo(`Extra header click, status is ${this.isExtraNtfsCollapsed}`);
    });
  }

  @Builder
  buildCollapsedButtonText(res: ResourceStr) {
    Text(res)
      .draggable(false)
      .id(`${TAG}_Title_Content_Ntf`)
      .fontSize($r('app.float.ntf_extra_content_font'))
      .fontColor(this.colorModeVM?.ntfExtraContentColor)
      .foregroundBrightness(this.colorModeVM?.foregroundPrimaryOption)
      .fontWeight(FontWeight.Medium)
      .textOverflow({ overflow: TextOverflow.Ellipsis })
      .maxLines(1)
      .height('100%')
      .margin({
        left: I18n.isRTL(I18n.System.getSystemLanguage()) ? 0 : $r('app.float.ntf_extra_content_margin_left'),
        right: I18n.isRTL(I18n.System.getSystemLanguage()) ? $r('app.float.ntf_extra_content_margin_left') : 0,
      })
      .fontFamily('HarmonyHeiTi')
      .opacity(HEADER_CONTENT_OPACITY)
      .renderGroup(this.listContentConfig.renderGroupSwitch)
  }

  @Builder
  buildCollapsedButtonImage(res: ResourceStr) {
    Image(res)
      .id(`${TAG}_Title_Button_Image_Ntf`)
      .objectFit(ImageFit.Contain)
      .width($r('app.float.ntf_extra_content_image_width'))
      .height(DeviceHelper.isPC() ? $r('app.float.ntf_pc_extra_content_image_height') : $r('app.float.ntf_extra_content_image_height'))
      .fillColor(this.colorModeVM?.ntfButtonImageColor)
      .foregroundBrightness(this.colorModeVM?.foregroundPrimaryOption)
      .margin({
        right: $r('app.float.ntf_extra_content_image_margin_right'),
        top: DeviceHelper.isPC() ? $r('app.float.ntf_pc_extra_content_image_margin_top') : $r('app.float.ntf_extra_content_image_margin_top'),
        bottom: DeviceHelper.isPC() ? $r('app.float.ntf_pc_extra_content_image_margin_bottom') : $r('app.float.ntf_extra_content_image_margin_bottom')
      })
  }

  // 折叠/展开按钮
  @Builder
  CollapsedButton() {
    if (this.isExtraNtfsCollapsed) {
      this.buildCollapsedButtonText($r('app.string.ntf_extra_message_expand'));
      this.buildCollapsedButtonImage($r('app.media.ic_ntf_arrow_down'));
    } else {
      this.buildCollapsedButtonText($r('app.string.ntf_extra_message_collapse'));
      this.buildCollapsedButtonImage($r('app.media.ic_ntf_arrow_up'));
    }
  }

  // 更多通知 文字
  @Builder
  MoreNtfText() {
    Text($r('app.string.ntf_extra_message'))
      .draggable(false)
      .id(`${TAG}_Title_Extra_Ntf`)
      .fontSize($r('app.float.ntf_extra_title_font_size'))
      .maxFontScale(1)
      .fontColor(this.colorModeVM?.ntfCenterTitleColor)
      .foregroundBrightness(this.colorModeVM?.foregroundPrimaryOption)
      .fontWeight(FontWeight.Medium)
      .textOverflow({ overflow: TextOverflow.Ellipsis })
      .maxLines(1)
      .flexShrink(0)
      .textShadow({
        radius: 5,
        color: 'rgba(0, 0, 0, 0.2)',
      })
      .renderGroup(this.listContentConfig.renderGroupSwitch)
      .constraintSize({
        minHeight: I18n.System.getSystemLanguage() === 'bo'
          ? $r('app.float.ntf_extra_button_line_height')
          : $r('app.float.ntf_extra_title_height')
      })
      .margin({
        start: LengthMetrics.resource($r('app.float.ntf_extra_title_margin_start'))
      })
      .accessibilityLevel('yes')
  }

  private changeTransparentCardHeight(): void {
    animateTo({
      duration: 333,
      curve: NtfAnimationConsts.GROUP_ITEM_EXPAND_CURVE,
    }, () => {
      this.transparentCardHeight = 0;
    });
  }
}