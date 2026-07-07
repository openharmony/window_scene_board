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
import {
  ArrayUtils,
  CommonUtils,
  LogDomain,
  LogHelper
} from '@ohos/basicutils';
import { DeviceHelper, EventManager, EvtBus } from '@ohos/frameworkwrapper';
import { RTLUtil } from '@ohos/componenthelper';
import { SCBConstants } from '@ohos/commonconstants';
import { NotificationActionView } from '../common/NotificationActionView';
import curves from '@ohos.curves';
import NtfMgr from '@ohos.notificationManager';
import {
  AodStyleType,
  BannerDeformState,
  bannerMgr,
  ImmersiveAodStyle,
  immersiveKgMgr,
  ObservedItem,
  OverlayIconStyle
} from '@ohos/systemuicommon';
import { fontScaleManager, FontScaleState, NtfMultiLineContent } from '@ohos/systemuicommon';
import { BrightnessOptionUtils } from '@ohos/systemuicommon/Index';
import { hideBannerNtfContentObj } from '../../model/HideBannerNtfContentObj';
import { NtfAppIconModifier } from '../../vm/style/NtfAppIconModifier';
import { NtfTimeVM } from '../../vm/NtfTimeVM';
import { NtfColorModeVM } from '../../vm/NtfColorModeVM';
import { AccessibilityAppName, NotificationType } from '@ohos/systemuicommon/Index';
import { ntfViewConfigManager } from '../../vm/config/NtfViewConfigManager';
import { NtfListContentConfig } from '../../vm/config/NtfViewConfig';
import pinTopIcon from '../common/PinTopIcon';
import { NotificationConstants } from '../../common/NotificationConstants';
import { NtfAnimationConsts } from '../../common/NtfAnimationConsts';
import { TextEmojiHelper } from '@ohos/systemuicommon/src/main/ets/utils/TextEmojiHelper';
import { image } from '@kit.ImageKit';
import { LengthMetrics } from '@ohos.arkui.node';
import { NtfSingleItemVM } from '../../vm/NtfSingleItemVM';
import { WDefault } from '@ohos/screenlockcommon/src/main/ets/immersivekgcommon/base/constants/WidgetPropertyConst';
import { AppProtectedVm } from '@ohos/systemuicommon/src/main/ets/vm/AppProtectedVm';
import { NotificationGroupExpandAnimation } from '../../animation/NotificationGroupExpandAnimation';
import { NotificationUtils } from '../../common/NotificationUtils';
import { ResUtils } from '@ohos/windowscene/src/main/ets/utils/ResourceUtils';
import { ExtraNtfCollapseEvent } from '../../common/event/NotificationEvent';
import { DeliverBadge } from '@ohos/systemuicommon/src/main/ets/view/DeliverBadge';
import { NotificationCollaBadgeViewV1 } from '@ohos/systemuicommon/src/main/ets/view/NotificationCollaBadgeViewV1'
import { NtfHeadsUpVM } from '../../vm/NtfHeadsUpVM';
import { MediaPlaybackControllerItem } from '@ohos/mediacontrolcomponent';
import { SysTypeCode } from '@ohos/systemuicommon';
const TAG = 'NotificationContent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

/**
 * 通知内容
 */
@Component
export struct NotificationContent {
  /**
   * 通知数据
   */
  @Consume @Watch('onNtfEntryModify') ntfEntry: NotificationEntry;
  private isInGroup: boolean = false;
  private isInAggregate: boolean = false;
  private isHeadsUp: boolean = false;
  /**
   * 形变相关参数
   */
  @Prop bannerDeformState: BannerDeformState | undefined = undefined;

  /**
   * 通知是否置顶显示
   */
  @State isDisplayAtTop: boolean = false;

  /**
   * 通知面板类型
   */
  @Consume notificationType: number;

  /**
   * AOD显示样式
   */
  @State aodStyle: ImmersiveAodStyle | undefined = immersiveKgMgr.getOneMirrorState().getAodStyle(
    this.notificationType === NotificationType.TYPE_PHONE_KEYGUARD);

  @State colorModeVM: NtfColorModeVM | undefined = undefined;
  /**
   * 长辈模式字体
   */
  @State fontScaleState: FontScaleState = fontScaleManager.getSysFontScaleState();

  private radius: BorderRadiuses = { topLeft: 0, topRight: 0, bottomLeft: 0, bottomRight: 0 };

  /**
   * 是否开启辅助功能朗读模式
   */
  @StorageProp('isAccessibilityMode') isAccessibilityMode: boolean = false;
  /**
   * 通知位置
   */
  private index: number = 0;
  /**
   * 第一条更多通知的动效延迟时间
   */
  private fisrtExtraNtfDelayTime: number | undefined = undefined;
  /**
   * 最后索引
   */
  private lastIndex: number = 0;
  /**
   * 通知内容动效参数
   */
  private textTranAnimParam: TransitionEffect = TransitionEffect.IDENTITY;
  private ntfDataUpdateListener: NtfDataUpdateListener = {
    onNtfDataUpdate: (newEntry: NotificationEntry): void => {
      this.ntfEntry = newEntry;
      if (this.ntfEntry) {
        // 通知是否置顶显示
        this.isDisplayAtTop = this.ntfEntry?.isDisplayAtTop;
        this.appName = this.ntfEntry.appName;
        this.appIcon = this.ntfEntry.getAppIcon(this.isUseAppIcon(), this.isProtectedInScreenLocked());
        this.overlayIcon = this.ntfEntry.overlayIcon;
      }
    }
  }
  /**
   * 应用名称
   */
  @State appName?: ObservedItem<string> = undefined;
  /**
   * 时间戳VM
   */
  @State timeVm: NtfTimeVM | undefined = undefined;
  /**
   * 缓存时间戳
   */
  private deliveryTime: number = 0;

  persistentId: number = 0;
  /**
   * 记录展示按钮的通知的哈希值，用于互斥操作
   */
  @Consume displayButtonsHashCode: string;

  private listContentConfig: NtfListContentConfig = ntfViewConfigManager.getListContentConfig();

  private textEmojiHelper: TextEmojiHelper = new TextEmojiHelper();

  /** 加锁通知的数量 */
  @Prop ntfCount: number = 1;
  /**
   * 应用图标
   */
  @State appIcon: image.PixelMap | string | Resource | undefined = undefined;

  @State overlayIcon: image.PixelMap | undefined = undefined;

  /**
   * 是否组通知展开
   */
  @Prop isClicked: boolean = false;
  /**
   * 组通知第一个item的hash code
   */
  @Prop firstItemHashCode: string = '';

  /**
   * 下拉DropBar是否可见
   */
  private isDropBarVisible: boolean = false;

  @State safePadding: LengthMetrics = this.listContentConfig.safePadding;

  @Prop isNeedBannerInScreenLock: boolean = false;
  @Prop isShowBannerFromScreenLock: boolean = false;
  @Prop isLockScreen: boolean = false;

  @State protectedVm: AppProtectedVm = AppProtectedVm.get();

  private ntfItemVM?: NtfSingleItemVM;

  private onSafePaddingChange: (safePadding: LengthMetrics) => void = (safePadding: LengthMetrics) => {
    this.safePadding = safePadding;
  }
  @Prop isInitParam: boolean = false;

  /**
   * 是否扩展新形态小外屏
   */
  @Prop isOuterHomeFolded: boolean = false;
  /**
   * 通知文本裁剪
   */
  @State textClip: boolean = true;
  /**
   * 多事件统一管理
   */
  private eventMgr: EventManager = EvtBus.createEventManager();
  /**
   * 横幅VM
   */
  public headsUpVM?: NtfHeadsUpVM;

  onNtfEntryModify() {
    if (!this.ntfEntry) {
      return;
    }

    if (this.deliveryTime !== this.ntfEntry.deliveryTime) {
      this.deliveryTime = this.ntfEntry.deliveryTime;
      this.timeVm?.update(this.deliveryTime);
    }
    this.appName = this.ntfEntry.appName;
  }

  aboutToAppear() {
    log.showInfo('aboutToAppear');
    if (this.ntfEntry) {
      this.isDisplayAtTop = this.ntfEntry.isDisplayAtTop;
      this.ntfEntry.registerDataUpdateListener(this.ntfDataUpdateListener);
      this.deliveryTime = this.ntfEntry.deliveryTime;
      this.timeVm?.init(this.deliveryTime, this.ntfEntry.hashCode);
      this.appName = this.ntfEntry.appName;
      this.appIcon =
        this.ntfEntry.getAppIcon(this.isUseAppIcon(), this.isProtectedInScreenLocked());
      this.overlayIcon =
        this.ntfEntry.overlayIcon;
      this.listContentConfig.safePaddingChangedSet.add(this.onSafePaddingChange);
    }
    this.eventMgr.on(ExtraNtfCollapseEvent, this.onExtraNtfCollapseEvent)
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisappear');
    this.timeVm?.deinit();
    this.ntfEntry?.unregisterDataUpdateListener(this.ntfDataUpdateListener);
    this.listContentConfig.safePaddingChangedSet.delete(this.onSafePaddingChange);
    this.eventMgr.offAll();
  }

  getNtfEntry(): NotificationEntry {
    return this.ntfEntry;
  }

  /**
   * 锁屏场景下保护态应用通知需要适配豁免名单，通知中心不需要适配，这里要区分处理
   * isProtected为true 但是 isAppLocked为false时，标识应用的本条通知在豁免名单
   * 保护态 && !(锁屏通知且在豁免名单)
   *
   * @returns boolean
   */
  private isProtectedInScreenLocked(): boolean {
    let flag = this.protectedVm.isProtected(this.ntfEntry?.bundleIdxTag) &&
      !((this.notificationType === NotificationType.TYPE_PHONE_KEYGUARD ||
        this.notificationType === NotificationType.TYPE_PHONE_AOD) && !this.ntfEntry?.isAppLocked);
    return flag;
  }

  /**
   * 多行文本通知通知内容为空时需要做适配
   * 通知内容显示通知标题，通知标题显示应用名称
   *
   * @returns boolean
   */
  isTextEmptyStrings(linesText: string[]): boolean {
    if (!linesText || linesText.length === 0) {
      log.showInfo(`lineText is undefined  or 0 in length `)
      return true; // linesText 不存在或长度为0
    }

    for (let i = 0; i < linesText.length; i++) {
      if (!CommonUtils.isEmpty(linesText[i])) {
        return false;
      }
    }
    log.showInfo(`All entries are empty strings`)
    return true;
  }

  /**
   * 获取多行文本内容
   *
   * @return 内容
   */
  private getLinesText(): string[] {
    return (this.ntfEntry?.notificationContent as NtfMultiLineContent)?.linesText ?? [];
  }
  /**
   * 获取通知标题
   *
   * @return 标题
   */
  private getNtfTitle(): ResourceStr {
    let title = '';
    if (this.isProtectedInScreenLocked() || this.isHiddenBannerContent()) {
      title = this.appName?.value ?? '';
    } else if (this.ntfEntry?.isExpandable) {
      // 展开title
      title = this.getExpandedTitle();
    } else {
      // 普通title
      title = this.getContentTitle();
    }
    if (CommonUtils.isEmpty(title)) {
      title = this.ntfEntry?.appName?.value;
    }
    return CommonUtils.isEmpty(title) ? ' ' : title;
  }

  private getExpandedTitle(): string {
    if (this.ntfEntry.style === 'multiLine' && this.isTextEmptyStrings(this.getLinesText())) {
      // 没有通知内容显示应用名称
      return this.ntfEntry?.appName?.value;
    }
    return this.ntfEntry?.notificationContent?.expandedTitle;
  }

  private getContentTitle(): string {
    if (CommonUtils.isEmpty(this.ntfEntry?.notificationContent?.contentText)) {
      // 没有通知内容显示应用名称
      return this.ntfEntry?.appName?.value;
    }
    return this.ntfEntry?.notificationContent?.contentTitle;
  }

  /**
   * 获取通知内容
   *
   * @return 内容
   */
  private getNtfContent(): ResourceStr {
    // 展开content
    if (this.isProtectedInScreenLocked() || this.isHiddenBannerContent()) {
      return ResUtils.getInnerPluralByResource($r('app.plural.ntf_hide_content_count'), this.ntfCount);
    } else if (this.ntfEntry?.isExpandable) {
      return this.ntfEntry?.notificationContent?.expandedContentText;
    }
    let content = this.ntfEntry?.notificationContent?.contentText;
    if (CommonUtils.isEmpty(content)) {
      content = this.ntfEntry?.notificationContent?.contentTitle;
    }
    return CommonUtils.isEmpty(content) ? ' ' : content;
  }

  /**
   * 是否只使用应用图标
   * 允许pc scene board使用自定义图标
   *
   * @return true只使用应用图标
   */
  private isUseAppIcon(): boolean {
    if (this.isProtectedInScreenLocked() || CommonUtils.isInvalid(this.ntfEntry)) {
      return true;
    };
    if (DeviceHelper.isPC()) {
      let bundleName: string = this.ntfEntry?.creatorBundleName;
      return bundleName === SCBConstants.SCENE_BOARD_PKG ? false : true;
    };
    return true;
  }

  // 隐藏横幅通知条件函数
  private isHiddenBannerContent(): boolean {
    if (DeviceHelper.isPC()) {
      return this.ntfEntry.isHideContent && this.isHeadsUp;
    }
    if (bannerMgr.isHiddenBannerContent(this.ntfEntry?.isHideContent, this.isNeedBannerInScreenLock,
      this.isShowBannerFromScreenLock)) {
      return true;
    }
    return false;
  }

  build() {
    // 媒体播放通知
    if (this.isMediaPlayer()) {
      MediaPlaybackControllerItem({
        onIconClickV2: this.onMediaCenterIconClick,
        isScreenLock: Boolean(this.onMediaCenterIconClick),
        notifyId: this.ntfEntry?.hashCode,
        isNotificationFromDeviceChange: false,
        itemData: undefined,
        ntfPanelVisible: true
      })
    } else if (this.isProtectedInScreenLocked() ||
    ArrayUtils.isEmpty(this.ntfEntry?.actionButtons)) {
      // 普通通知
      this.buildNtfCommon();
    } else { // 帶按鈕通知
      Column() {
        this.buildNtfCommon(true);
        if (this.shouldShowActionButtons()) {
          NotificationActionView({
            persistentId: this.persistentId, isHeadsUp: this.isHeadsUp, isInGroup: this.isInGroup,
            colorModeVM: this.colorModeVM,
            radius: this.radius,
            isInAggregate: this.isInAggregate,
            isDropBarVisible: this.isDropBarVisible,
            ntfItemVM: this.ntfItemVM,
            isNeedPanelInScreenLock: this.isNeedBannerInScreenLock,
            isLockScreen: this.isLockScreen,
            headsUpVM: this.headsUpVM
          })
        }
      }
    }
  }

  private isMediaPlayer(): boolean {
    const liveViewData = this.ntfEntry?.liveViewData;
    return liveViewData?.sysTypeCode === SysTypeCode.BROADCASTING_CENTER;
  }

  private onMediaCenterIconClick = (): void => {
    // 处理媒体中心图标点击事件
  }

  @Builder
  buildNtfCommon(isWithActionButtons: boolean = false) {
    Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
      // 全场景通知，普通单通知显示设备来源图标;子通知不显示应用图标
      if (this.isProtectedInScreenLocked() && (!this.isInGroup || this.isInAggregate) &&
        this.ntfEntry.overlayIconStyle !== OverlayIconStyle.REVERSE) {
        this.buildNtfAppIcon();
      } else if (this.overlayIcon || this.ntfEntry.overlayIconStyle === OverlayIconStyle.REVERSE ||
        (this.ntfEntry.isCollaNotification && !this.isInGroup)) {
        // 对话类通知，显示自定义头像
        this.buildNtfHeadPortrait();
      } else {
        if (!this.isInGroup || this.isInAggregate) {
          // 单通知显示应用图标
          this.buildNtfAppIcon();
        }
      }

      Column() {
        AccessibilityAppName({
          name: this.appName?.value,
          isAccessibilityMode: this.isAccessibilityMode
        })
        this.buildNtfTitle();
        this.buildNtfContent();
      }
      .padding({ top: $r('app.float.ntf_content_padding_start_end') })
      .flexShrink(1)
      .flexGrow(1)
      .alignItems(HorizontalAlign.Start)
    }
    .height(this.isInitParam && this.bannerDeformState ?
      this.bannerDeformState.bannerHeight - this.getActionBtnHeight(isWithActionButtons) : undefined)
    .width('100%')
    .padding({ left: $r('app.float.ntf_item_padding_start_end'), right: $r('app.float.ntf_item_padding_start_end') })
    .accessibilityGroup(this.isAccessibilityMode)
  }

  @Builder
  buildNtfHeadPortrait() {
    if (this.ntfEntry.overlayIconStyle !== OverlayIconStyle.REVERSE || !this.isInGroup) {
      Stack() {
        Image(this.ntfEntry.overlayIconStyle === OverlayIconStyle.REVERSE ||
          (this.ntfEntry.isCollaNotification && !this.isInGroup && !this.overlayIcon) ?
          this.appIcon : this.overlayIcon)
          .id('head_portrait' + this.ntfEntry.hashCode)
          .opacity(this.aodStyle?.getNtfIconOpacity() ?? WDefault.MAX_VALUE)
          .transition(this.isHeadsUp || !this.isInGroup ? undefined :
          NotificationGroupExpandAnimation.getOverlayIconAnimation(this.index, this.lastIndex))
          .attributeModifier(new NtfAppIconModifier($r('app.float.ntf_small_icon_size_phone'),
            undefined, this.ntfEntry,
            false).setOnErrorEvent(() => {
            if (this.ntfEntry.overlayIconStyle === OverlayIconStyle.REVERSE) {
              this.appIcon = $r('app.media.icon')
            }
          }))
          .borderRadius(this.ntfEntry.overlayIconStyle === OverlayIconStyle.REVERSE ||
            this.ntfEntry.isCollaNotification ? undefined :
          $r('app.float.ntf_small_icon_with_overlay_icon_size_phone'))
        if (this.ntfEntry.overlayIconStyle !== OverlayIconStyle.REVERSE) {
          if (!this.isInGroup) {
            if (this.ntfEntry.isCollaNotification) {
              NotificationCollaBadgeViewV1({isOverlayIcon : !CommonUtils.isInvalid(this.overlayIcon)})
            } else {
              // 组通知展开时，不显示图标。
              Column()
                .width($r('app.float.ntf_small_icon_size'))
                .height($r('app.float.ntf_small_icon_size'))
                .borderRadius($r('app.float.ntf_action_button_radius'))
                .backgroundColor(this.aodStyle?.getStyleValue(AodStyleType.LIST_CARD_BACKGROUND_COLOR))
                .offset({ x: $r('app.float.ntf_small_icon_offset_phone'), y: $r('app.float.ntf_small_icon_offset_phone') })
              Image(this.appIcon)
                .id(this.ntfEntry?.hashCode + '_app_icon')
                .attributeModifier(new NtfAppIconModifier(undefined, undefined, undefined,
                  false).setOnErrorEvent(() => {
                  this.appIcon = $r('app.media.icon')
                }))
                .opacity(this.aodStyle?.getNtfIconOpacity() ?? WDefault.MAX_VALUE)
                .offset({ x: $r('app.float.ntf_small_icon_offset_phone'), y: $r('app.float.ntf_small_icon_offset_phone') })
            }
          }
        } else {
          DeliverBadge({
            isKgScene: this.notificationType === NotificationType.TYPE_PHONE_KEYGUARD,
          })
        }
      }
      .margin({
        end: this.overlayIcon && !this.isInGroup ?
        LengthMetrics.resource($r('app.float.ntf_item_overlay_padding_start_end')) :
        LengthMetrics.resource($r('app.float.ntf_item_padding_start_end')),
      })
      .flexShrink(0)
      .width(this.overlayIcon && !this.isInGroup ? $r('app.float.ntf_overlay_icon_size_phone') :
      $r('app.float.ntf_small_icon_size_phone'))
      .height(this.overlayIcon && !this.isInGroup ? $r('app.float.ntf_overlay_icon_size_phone') :
      $r('app.float.ntf_small_icon_size_phone'))
      .offset({
        start: this.overlayIcon && !this.isInGroup && !this.ntfEntry.isCollaNotification ?
        LengthMetrics.resource($r('app.float.ntf_overlay_icon_offset_phone')) : LengthMetrics.vp(0)
      })
      .renderGroup(this.overlayIcon && !this.isInGroup)
    }
  }

  @Builder
  buildNtfAppIcon() {
    Image(this.appIcon)
      .id(this.ntfEntry?.hashCode + '_image_app_icon')
      .attributeModifier(new NtfAppIconModifier($r('app.float.ntf_small_icon_size_phone'),
        $r('app.float.ntf_item_right_icon_radius'), this.ntfEntry, false).setOnErrorEvent(() => {
        this.appIcon = $r('app.media.icon')
      }))
      .margin({
        end: LengthMetrics.resource($r('app.float.ntf_item_padding_start_end'))
      })
      .flexShrink(0)
      .opacity(this.aodStyle?.isAod ? this.aodStyle.getStyleValue(AodStyleType.NTF_APP_ICON_ALPHA) : undefined)
  }

  @Builder
  buildPinTop() {
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
        .renderGroup(this.aodStyle?.isOneMirror ? false : true)
        .margin({ right: $r('app.float.ntf_item_date_time_margin'), left: $r('app.float.ntf_item_date_time_margin') })
        .fontColor(this.aodStyle?.isAod
          ? this.aodStyle?.getStyleValue(AodStyleType.FONT_COLOR)
          : this.colorModeVM?.bgPinTextColor)
        .foregroundBrightness(this.aodStyle?.isAod ? BrightnessOptionUtils.aodTimeLightOptionForFillColor :
          this.colorModeVM?.themeTimestampForegroundBrightnessOptions)
    }
  }

  @Builder
  buildTimestamp() {
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
      .visibility(this.aodStyle?.isAod ? Visibility.Hidden : Visibility.Visible)
      .renderGroup(this.aodStyle?.isOneMirror ? false : true)
  }

  private titleHaveEmoji(): boolean {
    let title = this.getNtfTitle();  
    if (typeof title === 'string') {
      return this.textEmojiHelper.isEmoji(title);
    }
    return false;
  }

  @Builder
  buildNtfTitle() {
    Row() {
      Text(this.getNtfTitle())
        .draggable(false)
        .id(TAG + '_Text_title')
        .maxLines(NotificationConfig.ITEM_CONTENT_SINGLE_LINE)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .fontWeight(FontWeight.Medium)
        .fontSize(this.fontScaleState.getScaleSize($r('app.float.ntf_title_font_size')))
        .fontFeature('\"ss08\" on')
        .fontColor(this.aodStyle?.isAod ? this.aodStyle?.getStyleValue(AodStyleType.FONT_COLOR) :
          this.colorModeVM?.ntfThemeTextPrimaryColor)
        .foregroundBrightness(this.colorModeVM?.foregroundPrimaryOptionOnBackground)
        .wordBreak(WordBreak.BREAK_ALL)
        .flexShrink(1)
        .geometryTransition(this.isInGroup && !this.checkIsFirstNtf() ?
        this.getTitleGeometryId(this.ntfEntry?.hashCode) : undefined, this.getGeometryTransitionOptions())
        .transition(this.isInGroup && this.checkIsFirstNtf() && this.isClicked ? this.getFirstTitleTransition() :
          undefined)
        .renderGroup(!(this.aodStyle?.isOneMirror) && !this.titleHaveEmoji())
        .lineHeight(this.fontScaleState.getScaleSize($r('app.float.ntf_text_line_height')))
        .clip(this.textClip)
        .textAlign(RTLUtil.isRTL() ? TextAlign.End : TextAlign.Start)

      Row() {
        // 置顶标识,聚合组内需要显示置顶按钮
        if ((this.isInAggregate || !this.isInGroup) && !this.isHeadsUp && this.isDisplayAtTop &&
          !this.ntfEntry.isEmergencyNtf()) {
          this.buildPinTop();
        }

        // 通知时间
        if (this.timeVm) {
          this.buildTimestamp();
        }
      }
      .margin({
        start: this.safePadding
      })
      .flexShrink(0)
      .transition(!this.isClicked ? TransitionEffect.IDENTITY : this.textTranAnimParam)
    }
    .height(this.fontScaleState.getScaleSize($r('app.float.ntf_text_line_height')))
    .width('100%')
    .margin({ bottom: '2vp' })
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.SpaceBetween)
  }

  @Builder
  buildNtfContentText(content: ResourceStr) {
    Text(content)
      .draggable(false)
      .maxLines(NotificationConfig.ITEM_CONTENT_SINGLE_LINE)
      .textOverflow({ overflow: TextOverflow.Ellipsis })
      .fontWeight(FontWeight.Regular)
      .fontSize(this.fontScaleState.getScaleSize($r('app.float.ntf_title_font_size')))
      .fontFeature('\"ss08\" on')
      .fontColor(this.aodStyle?.isAod ? this.aodStyle?.getStyleValue(AodStyleType.CARD_SECONDARY_FONT_COLOR) :
        this.colorModeVM?.themeFontForegroundColor)
      .lineHeight(this.fontScaleState.getScaleSize($r('app.float.ntf_text_line_height')))
      .wordBreak(WordBreak.BREAK_ALL)
      .clip(this.textClip)
  }

  @Builder
  buildNtfTextView() {
    Column() {
      if (this.isHiddenBannerContent()) {
        this.buildNtfContentText($r('app.string.ntf_hide_content', 1))
      } else {
        if (!this.isTextEmptyStrings(this.getLinesText())) {
          ForEach(this.getLinesText().slice(0,
            NotificationConfig.ITEM_CONTENT_MAX_LINE_PHONE), (item: string, index?: number) => {
            this.buildNtfContentText(item)
          }, (item: string) => {
            return item;
          })
        } else {
          //如果多行通知内容为空
          this.buildNtfContentText(this.ntfEntry?.notificationContent?.contentTitle ?? '')
        }
      }
    }
    .foregroundBrightness(this.aodStyle?.isAod ? this.colorModeVM?.themeFontForegroundOptions :
      this.colorModeVM?.themeFontForegroundBrightnessOptions)
    .alignItems(HorizontalAlign.Start)
    .id(TAG + '_MultiLines')
    .flexShrink(1)
    .padding({
      bottom: $r('app.float.ntf_item_padding_start_end')
    })
    .renderGroup((this.aodStyle?.isOneMirror || this.hasMultiLineEmoji()) ? false : true)
  }

  @Builder
  buildNtfTextContent() {
    if (!this.isProtectedInScreenLocked() &&
      this.ntfEntry.contentType === NtfMgr.ContentType.NOTIFICATION_CONTENT_MULTILINE) {
      this.buildNtfTextView();
    } else {
      Text(this.getNtfContent())
        .draggable(false)
        .id(TAG + '_Text_content')
        .maxLines(NotificationConfig.ITEM_CONTENT_MAX_LINE_PHONE)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .fontWeight(FontWeight.Regular)
        .fontSize(this.fontScaleState.getScaleSize($r('app.float.ntf_title_font_size')))
        .fontFeature('\"ss08\" on')
        .fontColor(this.aodStyle?.isAod ? this.aodStyle?.getStyleValue(AodStyleType.CARD_SECONDARY_FONT_COLOR) :
          this.colorModeVM?.themeFontForegroundColor)
        .foregroundBrightness(this.aodStyle?.isAod ? this.colorModeVM?.themeFontForegroundOptions :
          this.colorModeVM?.themeFontForegroundBrightnessOptions)
        .wordBreak(WordBreak.BREAK_ALL)
        .flexShrink(1)
        .padding({
          bottom: DeviceHelper.isPC() ? $r('app.float.ntf_pc_item_padding_start_end')
            : $r('app.float.ntf_item_padding_start_end')
        })
        .transition((this.getNtfEntry()?.isHeadsUp() || DeviceHelper.isPC()) ? null : this.getContentTranEffect())
        .renderGroup((this.aodStyle?.isOneMirror || this.hasEmoji()) ? false : true)
        .lineHeight(this.fontScaleState.getScaleSize($r('app.float.ntf_text_line_height')))
        .clip(this.textClip)
    }
  }

  private hasEmoji(): boolean {
    if (this.isHiddenBannerContent() || this.isProtectedInScreenLocked()) {
      return false;
    }
    let ntfContent = this.getNtfContent();
    log.showInfo(`typeof ntfContent: ${typeof ntfContent}`);
    if (typeof ntfContent === 'string') {
      return this.textEmojiHelper.isEmoji(ntfContent);
    }
    return false;
  }

  private hasMultiLineEmoji(): boolean {
    let hasEmoji = false;
    this.getLinesText().slice(0, NotificationConfig.ITEM_CONTENT_MAX_LINE_PHONE).forEach((item) => {
      if (this.textEmojiHelper.isEmoji(item)) {
        hasEmoji = true;
      }
    })
    return hasEmoji;
  }

  @Builder
  buildNtfContent() {
    Row() {
      // 不带图标通知
      if (this.isProtectedInScreenLocked() ||
      CommonUtils.isInvalid(this.ntfEntry.largeIcon)) {
        this.buildNtfTextContent();
      } else { // 带图标通知
        this.buildNtfTextContent();
        if (!this.isHiddenBannerContent()) {
          Image(this.ntfEntry.largeIcon)
            .id(TAG + '_Image')
            .draggable(false)
            .objectFit(ImageFit.Cover)
            .width($r('app.float.ntf_item_right_icon_size'))
            .height($r('app.float.ntf_item_right_icon_size'))
            .borderRadius($r('app.float.ntf_item_right_icon_radius'))
            .flexShrink(0)
            .margin({ start: LengthMetrics.resource($r('app.float.ntf_item_padding_start_end')), bottom: LengthMetrics.vp(6) })
            .interpolation(ImageInterpolation.Medium)
            .autoResize(false)
        }
      }
    }
    .width('100%')
    .alignItems(VerticalAlign.Top)
    .justifyContent(FlexAlign.SpaceBetween)
    .transition(!this.isClicked ? TransitionEffect.IDENTITY : this.textTranAnimParam)
  }

  private getTitleGeometryId(hashcode: string): string {
    let oriId = NotificationConstants.NTF_CONTENT_ID + hashcode + '_' + this.notificationType;
    if (this.notificationType === NotificationType.TYPE_PHONE_KEYGUARD) { // 锁屏面板，区分展开组通知场景
      return this.isInGroup ? oriId : '';
    }
    return oriId;
  }

  private getGeometryTransitionOptions(): GeometryTransitionOptions | null {
    // 锁屏场景或扩展新形态小外屏下元素共享组件继承父组件位移等属性
    return this.notificationType === NotificationType.TYPE_PHONE_KEYGUARD || this.isOuterHomeFolded ?
      { hierarchyStrategy: TransitionHierarchyStrategy.NONE } : null;
  }

  private checkIsFirstNtf(): boolean {
    return this.firstItemHashCode === this.ntfEntry?.hashCode;
  }

  private getFirstTitleTransition(): TransitionEffect {
    const isOverlay = Boolean(this.overlayIcon) || this.ntfEntry?.overlayIconStyle === OverlayIconStyle.REVERSE;
    return NtfAnimationConsts.getNtfGroupTitleTransition(isOverlay, this.fontScaleState.getFontScale(false), false);
  }

  private getContentTranEffect(): TransitionEffect {
    if (this.fisrtExtraNtfDelayTime) {
      return this.getFirstNtfTranEffect();
    }
    return TransitionEffect.IDENTITY;
  }

  private getFirstNtfTranEffect(): TransitionEffect {
    return TransitionEffect.asymmetric(
      TransitionEffect.translate({ x: 20 }).animation({ curve: NtfAnimationConsts.EXTRA_NTF_EXPAND_CURVE }),
      TransitionEffect.translate({ x: 20 })
        .animation({ delay: this.fisrtExtraNtfDelayTime, curve: NtfAnimationConsts.EXTRA_NTF_EXPAND_CURVE })
    );
  }

  private checkShouldDisplayButtons(): boolean {
    if (this.isHeadsUp) {
      return true;
    }
    return this.displayButtonsHashCode == this.ntfEntry?.hashCode;
  }

  private shouldShowActionButtons(): boolean {
    return this.checkShouldDisplayButtons() && !this.isHiddenBannerContent();
  }

  private getActionBtnHeight(isWithActionButtons: boolean): number {
    if (isWithActionButtons && this.shouldShowActionButtons()) {
      return NotificationUtils.getActionBtnHeight(true);
    }
    return 0;
  }

  private onExtraNtfCollapseEvent = (event: ExtraNtfCollapseEvent) => {
    if (this.ntfEntry?.isExtraContentType()) {
      this.textClip = false;
    }
  }
}