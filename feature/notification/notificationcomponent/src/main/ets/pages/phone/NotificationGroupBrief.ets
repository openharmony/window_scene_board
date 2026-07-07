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

import { NotificationEntry, NtfDataUpdateListener } from '../../model/NotificationEntry';
import { NotificationConfig } from '../../common/NotificationConfig';
import { CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { ItemUtils, RTLUtil } from '@ohos/componenthelper';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { AodStyleType, ImmersiveAodStyle, immersiveKgMgr,
  ObservedItem,
  OverlayIconStyle} from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { fontScaleManager, FontScaleState } from '@ohos/systemuicommon';
import { NotificationItemStyle } from '../../vm/style/NotificationItemStyle';
import { notificationStyle } from '../../vm/style/NotificationStyle';
import { NtfTimeVM } from '../../vm/NtfTimeVM';
import { NtfAppIconModifier } from '../../vm/style/NtfAppIconModifier';
import { AccessibilityAppName, BrightnessOptionUtils, NotificationType } from '@ohos/systemuicommon/Index';
import { NtfColorModeVM } from '../../vm/NtfColorModeVM';
import { ntfViewConfigManager } from '../../vm/config/NtfViewConfigManager';
import { NtfListContentConfig } from '../../vm/config/NtfViewConfig';
import pinTopIcon from '../common/PinTopIcon';
import { NtfAnimationConsts } from '../../common/NtfAnimationConsts';
import { NotificationConstants } from '../../common/NotificationConstants';
import {
  PromiseInterrupt
} from '@ohos/systemuicommon/src/main/ets/immersivekeyguardcommon/base/manager/PromiseInterruptManager';
import { LengthMetrics } from '@ohos.arkui.node';
import { TextEmojiHelper } from '@ohos/systemuicommon/src/main/ets/utils/TextEmojiHelper';
import { image } from '@kit.ImageKit';
import { NotificationGroupExpandAnimation } from '../../animation/NotificationGroupExpandAnimation';
import { NtfCloseVM } from '../../vm/NtfCloseVM';
import { NtfGroupItemModifier } from '../../model/NtfItemModifier';
import { ResUtils } from '@ohos/windowscene';
import { AccessibilityCollapsedState } from '@ohos/systemuicommon/src/main/ets/accessibility/AccessibilityAppName';
import { DeliverBadge } from '@ohos/systemuicommon/src/main/ets/view/DeliverBadge';
import { NotificationCollaBadgeViewV1 } from '@ohos/systemuicommon/src/main/ets/view/NotificationCollaBadgeViewV1';

const TAG = 'NotificationGroupBrief';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

/**
 * 分组通知概要
 */
@Component
export struct NotificationGroupBrief {
  /**
   * 长辈模式字体
   */
  @State fontScaleState: FontScaleState = fontScaleManager.getSysFontScaleState();
  /**
   * 是否开启辅助功能朗读模式
   */
  @StorageProp('isAccessibilityMode') isAccessibilityMode: boolean = false;
  /**
   * 分组通知数据
   */
  private ntfEntry?: NotificationEntry = undefined;

  /**
   * 分组通知个数
   */
  @Consume groupRemainderCount: string;

  /**
   * 隐藏通知内容时，几个通知
   */
  @Consume groupCountHideText: string;

  /**
   * 是否隐藏通知内容
   */
  @Consume isHideNtfContent: boolean;

  /**
   * 通知是否置顶显示
   */
  @State isDisplayAtTop: boolean = false;

  @State colorModeVM: NtfColorModeVM | undefined = undefined;

  /**
   * 是否点击展开
   */
  @Link @Watch('onClickExpand') isClicked: boolean;

  /**
   * 圆角
   */
  @Prop radius: number = 0;
  /**
   * 通知条目样式
   */
  private itemStyle: NotificationItemStyle = notificationStyle.item;

  /**
   * 简介图标距离顶部的位置
   */
  @Link briefIconPositionY: number;

  /**
   * 是否扩展新形态小外屏
   */
  @Prop isOuterHomeFolded: boolean = false;

  /**
   * 通知面板类型
   */
  @Consume notificationType: number;

  /**
   * Aod显示样式
   */
  @State aodStyle: ImmersiveAodStyle | undefined = immersiveKgMgr.getOneMirrorState().getAodStyle(
    this.notificationType === NotificationType.TYPE_PHONE_KEYGUARD);
  /**
   * 应用名称
   */
  @State appName?: ObservedItem<string> = this.ntfEntry?.appName;
  /**
   * 时间戳VM
   */
  @State timeVm: NtfTimeVM | undefined = undefined;

  @State childLength: number = 0;

  @State briefTitle: string[] = [];

  @State briefContent: string[] = [];

  @State briefAppName: string[] = [];

  private childEntries: NotificationEntry[] = [];

  @State private childHashcode: string[] = ['', ''];

  private dataChangeInterrupt?: PromiseInterrupt = undefined;

  /**
   * 缓存时间戳
   */
  private deliveryTime: number = 0;
  /**
   * 是否显示通知时间
   */
  private showDateTime: boolean = true;

  /**
   * 图标y值
   */
  private mIconY: number = 0;

  /**
   * 第一行文本y值
   */
  private mFirstTextY: number = 0;

  /**
   * 动效收起组通知回调
   */
  private animHeightChange?: (param: AnimateParam) => void;

  private listContentConfig: NtfListContentConfig = ntfViewConfigManager.getListContentConfig();

  private textEmojiHelper: TextEmojiHelper = new TextEmojiHelper();

  private ntfDataUpdateListener: NtfDataUpdateListener = {
    onNtfDataUpdate: (): void => {
      log.info(`ntfDataUpdateListener onNtfDataUpdate: ${this.ntfEntry?.uid} ${this.ntfEntry?.childrenEntry?.length}`);
      // 锁屏面板动效刷新
      if (this.notificationType === NotificationType.TYPE_PHONE_KEYGUARD && !this.aodStyle?.isAod) {
        this.onNtfEntryChange(this.itemStyle?.itemUpdateAnim);
        return;
      }
      this.onNtfEntryChange();
    }
  }
  /**
   * 应用图标
   */
  @State appIcon: image.PixelMap | string | Resource | undefined = undefined;
  @State overlayIcon: image.PixelMap | undefined = undefined;
  @State safePadding: LengthMetrics = this.listContentConfig.safePadding;
  private onSafePaddingChange: (safePadding: LengthMetrics) => void = (safePadding: LengthMetrics) => {
    this.safePadding = safePadding;
  }
  @Consume private closeVM?: NtfCloseVM;
  groupItemModifier?: NtfGroupItemModifier = DeviceHelper.isPC() ? new NtfGroupItemModifier(this.closeVM) : undefined;

  async onNtfEntryChange(anim?: AnimateParam) {
    if (!this.ntfEntry) {
      return;
    }
    // 数据刷新拦截等待
    await this.dataChangeInterrupt?.awaitInterrupt();
    this.childEntries = this.ntfEntry.childrenEntry ?? [];
    this.refreshTitleBrief(anim);
    if (this.deliveryTime !== this.ntfEntry?.deliveryTime) {
      this.timeVm?.update(this.ntfEntry?.deliveryTime);
      this.deliveryTime = this.ntfEntry?.deliveryTime;
    }
    this.appName = this.ntfEntry?.appName;
    this.appIcon = this.ntfEntry?.getAppIcon(true);
    this.overlayIcon = this.ntfEntry?.overlayIcon;
    // 通知是否置顶显示
    this.isDisplayAtTop = this.ntfEntry?.isDisplayAtTop;
  }

  aboutToAppear(): void {
    log.showInfo(`aboutToAppear: ${this.ntfEntry?.uid}`);
    if (this.ntfEntry) {
      this.isDisplayAtTop = this.ntfEntry?.isDisplayAtTop;
      if (this.showDateTime) {
        this.timeVm = new NtfTimeVM();
        this.deliveryTime = this.ntfEntry.deliveryTime;
        this.timeVm?.init(this.deliveryTime, this.ntfEntry.hashCode);
      }
      this.appIcon = this.ntfEntry?.getAppIcon(true);
      this.overlayIcon = this.ntfEntry?.overlayIcon;
    }
    // 注册数据刷新
    this.ntfEntry?.registerDataUpdateListener(this.ntfDataUpdateListener);
    this.onNtfEntryChange();
    this.listContentConfig.safePaddingChangedSet.add(this.onSafePaddingChange);
    this.groupItemModifier?.setEntry(this.ntfEntry);
  }

  aboutToDisappear(): void {
    log.showInfo(`aboutToDisappear`);
    this.timeVm?.deinit();
    this.ntfEntry?.unregisterDataUpdateListener(this.ntfDataUpdateListener);
    this.listContentConfig.safePaddingChangedSet.delete(this.onSafePaddingChange);
  }

  @Builder
  buildPinTopText() {
    if (this.listContentConfig.pinTopUseSymbolGlyph) {
      pinTopIcon()
    } else {
      Text($r('app.string.topped_notification_flag'))
        .draggable(false)
        .id(TAG + '_ntf_flag')
        .border({
          width: $r('app.float.ntf_pin_top_flag_border_width'),
          color: this.aodStyle?.isAod
            ? this.aodStyle?.getStyleValue(AodStyleType.FONT_COLOR)
            : this.colorModeVM?.bgPinTextColor,
          radius: $r('app.float.ntf_pin_top_flag_border_radius'),
          style: BorderStyle.Solid
        })
        .padding({
          top: $r('app.float.ntf_pin_top_flag_padding_vertical'),
          bottom: $r('app.float.ntf_pin_top_flag_padding_vertical'),
          left: $r('app.float.ntf_pin_top_flag_padding_horizontal'),
          right: $r('app.float.ntf_pin_top_flag_padding_horizontal')
        })
        .fontSize($r('app.float.ntf_pin_top_flag_font_size'))
        .fontWeight(FontWeight.Medium)
        .margin({ end: LengthMetrics.resource($r('app.float.ntf_item_date_time_margin')) })
        .geometryTransition(this.getGeometryTransitionId(), this.getGeometryTransitionOptions())
        .fontColor(this.aodStyle?.isAod
          ? this.aodStyle?.getStyleValue(AodStyleType.FONT_COLOR)
          : this.colorModeVM?.bgPinTextColor)
        .foregroundBrightness(this.aodStyle?.isAod ? BrightnessOptionUtils.aodTimeLightOptionForFillColor :
          this.colorModeVM?.themeTimestampForegroundBrightnessOptions)
        .renderGroup(this.aodStyle?.isOneMirror ? false : true)
    }
  }

  @Builder
  buildTimestamp() {
    if (this.showDateTime) {
      Text(this.timeVm?.timeText)
        .draggable(false)
        .fontSize($r('app.float.ntf_app_time_font_size'))
        .maxFontScale(1)
        .fontColor(this.colorModeVM?.themeTimestampForegroundColor)
        .foregroundBrightness(this.colorModeVM?.themeTimestampForegroundBrightnessOptions)
        .fontWeight(FontWeight.Regular)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .id(`${TAG}_Text_${(this.ntfEntry as NotificationEntry).hashCode}`)
        .transition(TransitionEffect.translate({ y: this.isClicked ? 30 : 0 }))
        .visibility(this.aodStyle?.isAod ? Visibility.Hidden : Visibility.Visible)
        .height(this.fontScaleState.getScaleSize($r('app.float.ntf_text_title_height')))
        .renderGroup(this.aodStyle?.isOneMirror ? false : true)
    }
  }

  @Builder
  buildNtfAppIcon() {
    if (this.ntfEntry?.overlayIconStyle !== OverlayIconStyle.REVERSE && !this.ntfEntry?.isCollaNotification) {
      this.buildSingleIcon()
    } else {
      this.buildOverlayIcon()
    }
  }

  @Builder
  buildSingleIcon() {
    Image(this.appIcon)
      .attributeModifier(new NtfAppIconModifier($r('app.float.ntf_small_icon_size_phone'),
        $r('app.float.ntf_item_right_icon_radius'), this.ntfEntry, false).setOnErrorEvent(() => {
        this.appIcon = $r('app.media.icon')
      }))
      .flexShrink(0)
      .margin({
        end: LengthMetrics.resource($r('app.float.ntf_item_padding_start_end')),
      })
      .syncLoad(true)
      .geometryTransition(this.notificationType === NotificationType.TYPE_PHONE_KEYGUARD ? '' :
        this.ntfEntry?.getGroupTypeKey() + '_' + this.notificationType + '_AppIcon',
        { hierarchyStrategy: TransitionHierarchyStrategy.NONE })
      .transition(this.checkAnimState() ? undefined : NotificationGroupExpandAnimation.getIconTransEffect(false,
        this.briefIconPositionY))
      .opacity(this.aodStyle?.isAod ? this.aodStyle.getStyleValue(AodStyleType.NTF_APP_ICON_ALPHA) : undefined)
      .id(this.ntfEntry?.getGroupTypeKey() + '_' + this.notificationType + '_BriefAppIcon')
  }

  @Builder
  buildOverlayIcon() {
    Stack() {
      Image(this.appIcon)
        .attributeModifier(new NtfAppIconModifier($r('app.float.ntf_small_icon_size_phone'),
          $r('app.float.ntf_item_right_icon_radius'), this.ntfEntry, false).setOnErrorEvent(() => {
          this.appIcon = $r('app.media.icon')
        }))
        .geometryTransition(this.notificationType === NotificationType.TYPE_PHONE_KEYGUARD ? '' :
          this.ntfEntry?.getGroupTypeKey() + '_' + this.notificationType + '_AppIcon',
          { hierarchyStrategy: TransitionHierarchyStrategy.NONE })
        .transition(this.checkAnimState() ? undefined : NotificationGroupExpandAnimation.getIconTransEffect(false,
          this.briefIconPositionY))
        .opacity(this.aodStyle?.isAod ? this.aodStyle.getStyleValue(AodStyleType.NTF_APP_ICON_ALPHA) : undefined)
        .id(this.ntfEntry?.getGroupTypeKey() + '_' + this.notificationType + '_BriefAppIcon')
      if(this.ntfEntry?.isCollaNotification) {
        // 全场景通知，组通知未展开时显示设备来源
        NotificationCollaBadgeViewV1({
          geometryTransitionId : this.notificationType === NotificationType.TYPE_PHONE_KEYGUARD ? '' :
            this.ntfEntry?.getGroupTypeKey() + '_' + this.notificationType + '_CollaBadge'
        })
      } else {
        DeliverBadge({
          geometryTransitionId: this.notificationType === NotificationType.TYPE_PHONE_KEYGUARD ? '' :
            this.ntfEntry?.getGroupTypeKey() + '_' + this.notificationType + '_OverlayIcon',
          isKgScene: this.notificationType === NotificationType.TYPE_PHONE_KEYGUARD,
        })
      }
    }
    .flexShrink(0)
    .margin({
      end: LengthMetrics.resource($r('app.float.ntf_item_padding_start_end')),
    })
    .width($r('app.float.ntf_small_icon_size_phone'))
    .height($r('app.float.ntf_small_icon_size_phone'))
  }

  @Builder
  buildNtfTitleLabel() {
    Row() {

      if (this.isDisplayAtTop) {
        this.buildPinTopText();
      }

      this.buildTimestamp();
    }
    .margin({ start: this.safePadding })
    .flexShrink(0)
    .transition(TransitionEffect.opacity(this.isClicked ? 0 : 1).animation({ duration: 100 }))
  }

  @Builder
  buildRemainderCount() {
    Stack({ alignContent: Alignment.Center }) {
      // 标示通知个数
      Text(this.groupRemainderCount)
        .draggable(false)
        .id(TAG + '_Text_groupRemainderCount')
        .maxLines(NotificationConfig.ITEM_CONTENT_SINGLE_LINE)
        .fontSize($r('app.float.ntf_remainder_count_font_size'))
        .maxFontScale(FontScaleState.systemUIMaxScale)
        .fontWeight(FontWeight.Medium)
        .fontColor(this.aodStyle?.isAod ? this.aodStyle?.getStyleValue(AodStyleType.CAPSULE_MAIN_FONT_COLOR) :
          this.colorModeVM?.ntfRemainderCountTextColor)
        .foregroundBrightness(this.aodStyle?.isAod ? this.colorModeVM?.aodTimeLightOptionForFillColor :
          this.colorModeVM?.themeFontForegroundBrightnessOptions)
        .flexShrink(0)
        .opacity(DeviceHelper.isPC() ? 1 : 0.6)
    }
    .width(this.fontScaleState.getScaleSize($r('app.float.nft_brief_remain_count_width')))
    .height(this.fontScaleState.getScaleSize($r('app.float.ntf_remain_count_height')))
    .flexShrink(0)
    .margin({
      start: LengthMetrics.resource($r('app.float.ntf_item_padding_start_end')),
      top: $r('app.float.ntf_header_common_margin_top')
    })
    .borderRadius('14vp')
    .backgroundColor(this.colorModeVM?.themeRemainderCountColor)
    .backgroundBrightnessInternal(this.aodStyle?.isAod ? this.colorModeVM?.aodTimeLightOptionForButtonBgColor :
      this.colorModeVM?.themeGroupRemainderCountOptions)
    .transition(this.isClicked ? TransitionEffect.translate({ y: 30 })
      .animation({ curve: NtfAnimationConsts.GROUP_DETAIL_EXPAND_CURVE })
      .combine(TransitionEffect.OPACITY.animation({ duration: 100 })) : undefined)
  }

  @Builder
  buildAppName() {
    AccessibilityCollapsedState({
      state: ResUtils.getInnerString($r('app.string.cc_accessibility_str_ntf_swipe_right_text')),
      isAccessibilityMode: this.isAccessibilityMode
    })
    AccessibilityAppName({
      name: this.appName?.value,
      isAccessibilityMode: this.isAccessibilityMode
    })
  }

  @Builder
  buildBriefContent() {
    Column() {
      this.buildAppName()
      // 隐藏通知内容，显示 几个通知
      if (this.isHideNtfContent) {
        Row() {
          Text(this.appName?.value)
            .draggable(false)
            .id(TAG + '_appName')
            .fontSize(this.fontScaleState.getScaleSize($r('app.float.ntf_title_font_size')))
            .fontColor(this.aodStyle?.isAod ? this.aodStyle?.getStyleValue(AodStyleType.FONT_COLOR)
              : $r('app.color.theme_ntf_color_text_primary'))
            .fontWeight(FontWeight.Medium)
            .fontFeature('\"ss08\" on')
            .maxLines(NotificationConfig.LAYOUT_WEIGHT_ONE)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .renderGroup(this.aodStyle?.isOneMirror ? false : true)
            .flexShrink(1)

          Row() {
            // 置顶标识
            if (this.isDisplayAtTop) {
              this.buildPinTopText();
            }

            this.buildTimestamp();
          }
          .margin({
            start: this.safePadding
          })
        }
        .width('100%')
        .height(this.fontScaleState.getScaleSize($r('app.float.ntf_text_title_height')))
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.SpaceBetween)

        Text(this.groupCountHideText)
          .draggable(false)
          .id(TAG + '_Text_groupCountHideText')
          .fontWeight(FontWeight.Regular)
          .fontSize($r('app.float.ntf_title_font_size'))
          .maxFontScale(FontScaleState.systemUIMaxScale)
          .fontColor(this.aodStyle?.isAod ? this.aodStyle?.getStyleValue(AodStyleType.CARD_SECONDARY_FONT_COLOR) :
            this.colorModeVM?.themeFontForegroundColor)
          .foregroundBrightness(this.aodStyle?.isAod ? this.colorModeVM?.themeFontForegroundOptions :
            this.colorModeVM?.themeFontForegroundBrightnessOptions)
          .lineHeight(this.fontScaleState.getScaleSize($r('app.float.ntf_text_line_height')))
          .maxLines(NotificationConfig.ITEM_CONTENT_SINGLE_LINE)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .margin({ top: '2vp' })
      } else { // 正常摘要
        ForEach(this.childHashcode, (hashcode: string, index?: number) => {
          this.buildContent(hashcode, index);
          }, (hashcode: string) => {
            return hashcode;
          })
      }
    }
    .flexShrink(1)
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  buildContentItem(hashcode: string, index?: number) {
    Flex() {
      // 第一条通知标题 摘要
      this.buildNtfTitle(hashcode);
      this.buildNtfSummary(hashcode, index)
    }
    .draggable(false)
    .flexShrink(1)
    .margin({ top: (index !== 0) && !DeviceHelper.isPC() ? '4vp' : undefined })
    .id(this.ntfEntry?.getGroupTypeKey() + '_' + this.notificationType + '_contentItem_' + index)
  }

  @Builder
  buildNtfTitle(hashcode: string) {
    Text() {
      // 通知标题
      Span(this.getBriefTitleText(hashcode))
        .fontWeight(FontWeight.Medium)
        .fontSize(this.fontScaleState.getScaleSize($r('app.float.ntf_title_font_size')))
        .fontColor(this.aodStyle?.isAod ? this.aodStyle?.getStyleValue(AodStyleType.FONT_COLOR) :
          this.colorModeVM?.ntfThemeTextPrimaryColor)
      // 这里利用中文空格，并设置宽度为8vp，使其达到8vp的宽度占用
      if (!RTLUtil.isRTL()) {
        Span('\u3000')
          .fontColor(Color.Transparent)
          .fontSize(this.fontScaleState.getScaleSize($r('app.float.ntf_group_brief_title_and_content_margin')))
      }
    }
    .textAlign(RTLUtil.isRTL() ? TextAlign.End : TextAlign.Start)
    .foregroundBrightness(this.colorModeVM?.foregroundPrimaryOptionOnBackground)
    .fontFeature('\"ss08\" on')
    .lineHeight(this.fontScaleState.getScaleSize($r('app.float.ntf_text_title_line_height')))
    .maxLines(NotificationConfig.ITEM_CONTENT_SINGLE_LINE)
    .textOverflow({ overflow: TextOverflow.Ellipsis })
    .wordBreak(WordBreak.BREAK_ALL)
    .geometryTransition(this.isClicked && !this.checkIsFirstNtf(hashcode) ? this.getTitleGeometryId(hashcode) :
      undefined, { hierarchyStrategy: TransitionHierarchyStrategy.NONE })
    .transition(this.isClicked && this.checkIsFirstNtf(hashcode) ? this.getTitleTransition() : undefined)
    .flexShrink(0)
    .height(this.fontScaleState.getScaleSize($r('app.float.ntf_text_line_height')))
    .renderGroup((this.aodStyle?.isOneMirror || this.textEmojiHelper.isEmoji(this.getBriefTitleText(hashcode))) ?
      false : true)
  }

  private getBriefTitleText(hashcode: string) {
    const index = this.getIndex(hashcode);
    if (CommonUtils.isEmpty(this.briefTitle[index]) ||
      CommonUtils.isEmpty(this.briefContent[index])) {
      return index > -1 ? this.briefAppName[index] ?? '' : '';
    }
    return index > -1 ? this.briefTitle[index] ?? '' : '';
  }

  @Builder
  buildNtfSummary(hashcode: string, index?: number) {
    Text() {
      if (RTLUtil.isRTL()) {
        Span('\u3000')
          .fontColor(Color.Transparent)
          .fontSize(this.fontScaleState.getScaleSize($r('app.float.ntf_group_brief_title_and_content_margin')))
      }
      // 通知摘要
      Span(this.getBriefContentText(hashcode))
        .fontWeight(FontWeight.Regular)
        .fontSize(this.fontScaleState.getScaleSize($r('app.float.ntf_title_font_size')))
        .fontColor(this.aodStyle?.isAod ? this.aodStyle?.getStyleValue(AodStyleType.CARD_SECONDARY_FONT_COLOR) :
          this.colorModeVM?.ntfThemeTextSecondaryColor)
    }
    .textAlign(TextAlign.Start)
    .foregroundBrightness(this.colorModeVM?.themeFontForegroundOptions)
    .fontFeature('\"ss08\" on')
    .lineHeight(this.fontScaleState.getScaleSize($r('app.float.ntf_text_title_line_height')))
    .maxLines(NotificationConfig.ITEM_CONTENT_SINGLE_LINE)
    .textOverflow({ overflow: TextOverflow.Ellipsis })
    .padding({ end: LengthMetrics.resource($r('app.float.ntf_pin_top_flag_padding_horizontal'))})
    .wordBreak(WordBreak.BREAK_ALL)
    .flexShrink(1)
    .transition(this.isClicked ? this.getTextTranEffect(index ?? 0) : TransitionEffect.IDENTITY)
    .height(this.fontScaleState.getScaleSize($r('app.float.ntf_text_line_height')))
    .renderGroup((DeviceHelper.isPC() ||
      this.aodStyle?.isOneMirror ||
      this.textEmojiHelper.isEmoji(this.getBriefContentText(hashcode))) ?
      false : true)
    .layoutWeight(1)
  }

  private getBriefContentText(hashcode: string) {
    const index = this.getIndex(hashcode);
    if (CommonUtils.isEmpty(this.briefTitle[index])) {
      return index > -1 ? this.briefContent[index] ?? '' : '';
    } else if (CommonUtils.isEmpty(this.briefContent[this.getIndex(hashcode)])) {
      return index > -1 ? this.briefTitle[index] ?? '' : '';
    }
    return index > -1 ? this.briefContent[index] ?? '' : '';
  }

  @Builder
  buildContent(hashcode: string, index?: number) {
    Row() {
      this.buildContentItem(hashcode, index);

      if (index === 0 && (this.isDisplayAtTop || this.showDateTime)) {
        this.buildNtfTitleLabel()
      }

      if (index === (this.childLength - 1) &&
        !CommonUtils.isEmpty(this.groupRemainderCount)) {
        this.buildRemainderCount()
      }
    }
    .height((index === 0) ? this.fontScaleState.getScaleSize($r('app.float.ntf_text_line_height')) : undefined)
    .width('100%')
    .alignItems(VerticalAlign.Bottom)
    .justifyContent(FlexAlign.SpaceBetween)
    .margin({ top: (index !== 0) && DeviceHelper.isPC() ? '4vp' : undefined })
  }

  build() {
    Row() {
      this.buildNtfAppIcon();
      this.buildBriefContent();
    }
    .width('100%')
    .alignItems(VerticalAlign.Center)
    .padding({
      left: $r('app.float.ntf_item_padding_start_end'),
      right: $r('app.float.ntf_item_padding_start_end'),
      top: $r('app.float.ntf_item_padding_start_end'),
      bottom: $r('app.float.ntf_item_padding_start_end')
    })
    .attributeModifier(this.groupItemModifier)
  }

  private getTitleGeometryId(hashcode: string): string {
    let oriId = NotificationConstants.NTF_CONTENT_ID + hashcode + '_' + this.notificationType;
    if (this.notificationType === NotificationType.TYPE_PHONE_KEYGUARD) { // 锁屏面板，区分展开组通知场景
      return this.isClicked ? oriId : '';
    }
    return oriId;
  }

  private getGeometryTransitionId(): string {
    // 扩展新形态小外屏增加后缀_OUTHOME, 避免内屏切外屏时后展开收起组通知'已置顶'文本一镜到底时先放大再缩小
    return NotificationConstants.NTF_PIN_TOP_ID + this.ntfEntry?.getGroupTypeKey() +
      '_' + this.notificationType + (this.isOuterHomeFolded ? '_OUTHOME' : '');
  }
  private getGeometryTransitionOptions(): GeometryTransitionOptions | null {
    // 锁屏场景或扩展新形态小外屏下元素共享组件继承父组件位移等属性
    return this.notificationType === NotificationType.TYPE_PHONE_KEYGUARD || this.isOuterHomeFolded ?
      { hierarchyStrategy: TransitionHierarchyStrategy.NONE } : null;
  }

  private getIndex(hashcode: string): number {
    let index = this.childEntries.findIndex((entry) => entry.hashCode === hashcode);
    log.showInfo(`getIndex, entry: ${this.childEntries[index]?.hashCode}, index : ${index}`);
    return index;
  }

  private refreshTitleBrief(anim?: AnimateParam) :void {
    let oldLength = this.childLength;
    this.childLength = Math.min(3, this.childEntries.length);
    this.childEntries.slice(0, this.childLength).forEach((entry, index) => {
      this.briefTitle[index] = entry.notificationContent?.contentTitle;
      this.briefContent[index] = entry.notificationContent?.contentText;
      this.briefAppName[index] = entry?.appName?.value;
    });
    let newChild = this.childEntries.map((entry) => entry.hashCode).slice(0, this.childLength);
    if (anim && oldLength !== this.childLength) { // 动效过渡
      this.animHeightChange?.(anim);
      animateTo(anim, () => this.updateChildHash(newChild));
    } else {
      this.updateChildHash(newChild);
    }
    log.showInfo(`refreshTitleBrief, length: ${this.childLength}`);
  }

  private updateChildHash(newChildHash: string[]): void { // 数据hash集刷新
    this.childHashcode.splice(0, this.childHashcode.length);
    this.childHashcode.push(...newChildHash);
  }

  private onClickExpand(): void {
    const mFirstTextY =
      ItemUtils.getRectById(this.ntfEntry?.getGroupTypeKey() + '_' + this.notificationType + '_contentItem_0')?.top;
    const mIconY =
      ItemUtils.getRectById(this.ntfEntry?.getGroupTypeKey() + '_' + this.notificationType + '_BriefAppIcon')?.top;
    const positionY = mFirstTextY - mIconY;
    if (Math.abs(positionY - this.briefIconPositionY) < Number.EPSILON) {
      return;
    }
    this.briefIconPositionY = positionY;
  }

  private checkAnimState(): boolean {
    return !this.isClicked || DeviceHelper.isPC() || this.notificationType !== NotificationType.TYPE_PHONE_KEYGUARD;
  }

  private getTextTranEffect(index: number): TransitionEffect {
    return TransitionEffect.asymmetric(
      TransitionEffect.translate({ y: 50 * index + 35 })
        .animation({ duration: 333, curve: NtfAnimationConsts.GROUP_ITEM_EXPAND_CURVE }).combine(
        TransitionEffect.OPACITY.animation({
          delay: 60,
          duration: 333,
          curve: NtfAnimationConsts.GROUP_ITEM_EXPAND_CURVE
        })),
      TransitionEffect.translate({ y: 50 * index + 35 })
        .animation({ duration: 333, curve: NtfAnimationConsts.GROUP_ITEM_EXPAND_CURVE }).combine(
        TransitionEffect.OPACITY.animation({
          duration: 200,
          curve: NtfAnimationConsts.GROUP_ITEM_EXPAND_CURVE
        }))
    );
  }

  private checkIsFirstNtf(hashcode: string): boolean {
    return this.childHashcode && hashcode === this.childHashcode[0];
  }

  private getTitleTransition(): TransitionEffect {
    const isOverlay =
      Boolean(this.childEntries[0]?.overlayIcon) || this.childEntries[0]?.overlayIconStyle === OverlayIconStyle.REVERSE;
    return NtfAnimationConsts.getNtfGroupTitleTransition(isOverlay, this.fontScaleState.getFontScale(false), true);
  }
}