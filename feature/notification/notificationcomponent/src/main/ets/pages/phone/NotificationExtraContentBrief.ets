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
import { RTLUtil } from '@ohos/componenthelper'
import { EventManager, EvtBus } from '@ohos/frameworkwrapper';
import { ResUtils } from '@ohos/windowscene'
import { NotificationExtraMenuRow } from './NotificationExtraMenuRow';
import { NtfItemSwipeController } from '../../controller/NtfItemSwipeController';
import { NotificationAnimationParas } from '../../common/NotificationAnimationParas';
import { AnimatorResult } from '@ohos.animator';
import { ResetItemSwipeEvent } from '../../common/event/NotificationEvent';
import { NotificationUtils } from '../../common/NotificationUtils';
import curves from '@ohos.curves';
import Curves from '@ohos.curves';
import { notificationStyle } from '../../vm/style/NotificationStyle';
import {
  ImmersiveAodStyle
} from '@ohos/systemuicommon/src/main/ets/immersivekeyguardcommon/base/interface/ImmersiveAodStyle';
import {
  immersiveKgMgr
} from '@ohos/systemuicommon/src/main/ets/immersivekeyguardcommon/manager/ImmersiveKeyguardStateManager';
import {
  NotificationConfigEvent,
  NotificationConfigEventType
} from '@ohos/systemuicommon/src/main/ets/model/NotificationConfigEvent';
import { NotificationType } from '@ohos/systemuicommon/Index';
import { NotificationItemStyle } from '../../vm/style/NotificationItemStyle';
import { NtfTimeVM } from '../../vm/NtfTimeVM';
import { NtfAppIconModifier } from '../../vm/style/NtfAppIconModifier';
import { NtfColorModeVM } from '../../vm/NtfColorModeVM';
import { NtfAnimationConsts } from '../../common/NtfAnimationConsts';
import { LengthMetrics } from '@ohos.arkui.node';
import i18n from '@ohos.i18n';
import { notificationConfigManager } from '../../manager/NotificationConfigManager';
import { NtfBrightnessMode, NtfListContentConfig } from '../../vm/config/NtfViewConfig';
import { ntfViewConfigManager } from '../../vm/config/NtfViewConfigManager';
import { NotificationAccessibilityUtil as AccessUtil } from '../../common/NotificationAccessibilityUtil';
import { ExtraNtfCollapsedAnimation } from '../../animation/ExtraNtfCollapsedAnimation';
import { AccessibilityCollapsedState } from '@ohos/systemuicommon/src/main/ets/accessibility/AccessibilityAppName';
import { OverlayIconStyle } from '@ohos/systemuicommon';
import { DeliverBadge } from '@ohos/systemuicommon/src/main/ets/view/DeliverBadge';

const TAG = 'NotificationExtraContentBrief';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

/**
 * 从右向左滑动，展开或关闭的临界值
 */
const SWIPE_LEFT_CRITICAL = 12;
const NTF_EXTRA_BRIEF_COUNT_THRESHOLD = 30;
const SWIPE_ANIM: AnimateParam = { curve: Curves.springCurve(0, 1, 228, 23) };

/**
 * 分组通知概要
 */
@Component
export struct NotificationExtraContentBrief {
  /**
   * 分组通知数据
   */
  @Consume @Watch('onNtfListChange') extraNtfList: Array<NotificationEntry>;
  /**
   * 面板触摸事件down点
   */
  @Consume @Watch('onGlobalDownYChange') panelDownGlobalY: number;
  /**
   * 是否开启辅助功能朗读模式
   */
  @StorageProp('isAccessibilityMode') isAccessibilityMode: boolean = false;
  @State contentBrief: string = '';
  @State translateX: number = 0;
  private iconSize = ResUtils.getNumber($r('app.float.ntf_small_icon_size_phone'));

  private onClickCB: () => void = () => {};

  /**
   * 侧滑时记录起始位移
   */
  private startTranX: number = 0;

  /**
   * 通知条目横向平移动画
   */
  private itemTranAnim: AnimateParam | null = null;
  /**
   * 记录左滑状态的通知的哈希值，用于左滑状态互斥（同一时刻，只允许一条通知左滑）
   */
  @Consume @Watch('onSwipeIdChange') swipeHashCode: string;
  /**
   * 多事件统一管理
   */
  private eventMgr: EventManager = EvtBus.createEventManager();
  /**
   * 横滑控制
   */
  private swipeController: NtfItemSwipeController = new NtfItemSwipeController();
  private menuWidth: number = 0;
  private itemArea?: Area;
  private hashCode: string = 'Brief_Code';

  private isRTL: boolean = RTLUtil.isRTL();
  /**
   * 按钮裁剪区域横向平移动画
   */
  private clipTranslateAnimator: AnimatorResult | undefined = undefined;
  private hasShadow: ShadowOptions = {
    radius: 2,
    color: $r('app.color.ntf_extra_brief_shadow_color'),
    offsetX: 2,
    offsetY: 0
  };
  private noShadow: ShadowOptions = {
    radius: 0,
    color: $r('app.color.ntf_extra_brief_shadow_color'),
    offsetX: 0,
    offsetY: 0
  };

  @ObjectLink ntfAniParameters: NotificationAnimationParas;
  /**
   * 展开状态
   */
  @Prop @Watch('changeTransitionEffect') isExtraNtfsCollapseStatusChanging: boolean = false;
  /**
   * 图标动效参数
   */
  @State iconTranEffectArrays: TransitionEffect[] = [];
  /**
   * 标题动效参数
   */
  @State textTranEffect: TransitionEffect = TransitionEffect.IDENTITY;

  @Link ntfExtraGroupBriefScale: number;

  /**
   * 窗口是否可见
   */
  @Consume @Watch('onWindowShowChange') isNtfWindowShow: boolean;

  /**
   * 通知面板类型
   */
  @Consume notificationType: number;

  /**
   * 通知条目样式
   */
  @State itemStyle: NotificationItemStyle = notificationStyle.item;

  @State colorModeVM: NtfColorModeVM | undefined = undefined;

  /**
   * Aod显示样式
   */
  @State aodStyle: ImmersiveAodStyle | undefined = immersiveKgMgr.getOneMirrorState().getAodStyle(
    this.notificationType === NotificationType.TYPE_PHONE_KEYGUARD);

  /**
   * 时间戳VM
   */
  @State timeVm: NtfTimeVM = new NtfTimeVM();

  /**
   * 通知中的最后一个，监听ntfEntry变化，触发列表图片刷新
   */
  private lastNtfEntry?: NotificationEntry = undefined;

  /**
   * 刷新标志，切换之后刷新更多通知图标
   */
  @State forceRefreshFlag: boolean = false;

  /**
   * 缓存时间戳
   */
  private deliveryTime: number = 0;

  /**
   * 记录切换的系统语言
   */
  private recordedSysLanguage: string = '';

  private ntfProductConfig: NtfListContentConfig = ntfViewConfigManager.getListContentConfig();

  /**
   * 窗口可见性切换
   */
  private onWindowShowChange(): void {
    if (this.isNtfWindowShow) {
      return;
    }
    // 当窗口隐藏时，收起横滑状态
    this.translateX = 0;
  }

  private onCloseSwipeEvent = (event: ResetItemSwipeEvent) => {
    if (CommonUtils.isInvalid(event)) {
      return;
    }
    if (this.hashCode === event?.ntfHashCode) {
      this.swipeController?.swipe2Collapse();
    }
  }

  private ntfDataUpdateListener: NtfDataUpdateListener = {
    onNtfDataUpdate: (newEntry: NotificationEntry): void => {
      this.forceRefreshFlag = !this.forceRefreshFlag;
      if (this.isNeedUpdateContentBrief()) {
        Promise.resolve().then(() => {
          this.updateBrief();
        });
      }
    }
  }
  /**
   * 更对通知折叠收起动效管理类
   */
  private extraNtfCollapsedAnimation: ExtraNtfCollapsedAnimation | undefined = undefined;
  /**
   * 是否在折叠状态下重新创建卡片
   */
  private isCreatedExtraBriefWhenCollapsed: boolean = false;

  aboutToAppear(): void {
    log.showInfo(`aboutToAppear`);
    this.onNtfListChange();
    this.swipeController?.registerSwipeCallback(this);
    this.eventMgr.on(ResetItemSwipeEvent, this.onCloseSwipeEvent);
    this.recordedSysLanguage = i18n.System.getSystemLanguage();
    this.clipTranslateAnimator = undefined;
    this.deliveryTime = this.extraNtfList[0].deliveryTime;
    this.timeVm.init(this.deliveryTime, this.extraNtfList[0].hashCode);
    this.iconTranEffectArrays = this.getIconTranEffectWhenCollapsed();
    this.textTranEffect = this.getTextTranEffectWhenCollapsed();
  }

  aboutToDisappear(): void {
    log.showInfo(`aboutToDisappear`);
    this.timeVm.deinit();
    this.swipeController?.unregisterSwipeCallback(this);
    this.lastNtfEntry?.unregisterDataUpdateListener(this.ntfDataUpdateListener);
  }

  changeTransitionEffect(): void {
    if (!this.isExtraNtfsCollapseStatusChanging) {
      this.iconTranEffectArrays = this.getIconTranEffect();
      this.textTranEffect = this.getTextTranEffect();
    }
  }

  @Styles
  bgBrightnessStyle() {
    .backgroundColor(this.ntfProductConfig.brightnessMode === NtfBrightnessMode.Centralized &&
      this.colorModeVM?.isBrightnessEffect ? undefined : this.colorModeVM?.themeBgColor)
    .backgroundBrightnessInternal(this.ntfProductConfig.brightnessMode === NtfBrightnessMode.Centralized ?
      undefined : this.colorModeVM?.themeBgBrightnessOption)
  }

  @Builder
  buildTimestamp() {
    Text(this.timeVm.timeText)
      .draggable(false)
      .fontSize($r('app.float.ntf_app_time_font_size'))
      .maxFontScale(1)
      .fontColor(this.colorModeVM?.themeTimestampForegroundColor)
      .foregroundBrightness(this.colorModeVM?.themeTimestampForegroundBrightnessOptions)
      .fontWeight(FontWeight.Regular)
      .maxLines(1)
      .textOverflow({ overflow: TextOverflow.Ellipsis })
      .id(`${TAG}_Text_${this.extraNtfList[0]?.hashCode}`)
      .transition(TransitionEffect.OPACITY.animation({ duration: 116 }))
      .visibility(this.aodStyle?.isAod ? Visibility.Hidden : Visibility.Visible)
      .renderGroup(true)
  }

  build() {
    if (this.extraNtfList?.length && this.extraNtfList?.length > 0) {
      Stack({ alignContent: Alignment.End }) {
        this.buildExtraContent()
        if (this.translateX !== 0) {
          Row() {
            this.buildMenu()
          }.zIndex(-1)
        }
      }
      .borderRadius($r('app.float.ntf_list_content_border_radius'))
      .clip(true)
      .translate({
        y: NotificationUtils.getNtfItemTransY(this.ntfAniParameters)
      })
      .opacity(NotificationUtils.getNtfItemOpacity(this.ntfAniParameters))
      .scale({
        x: NotificationUtils.getNtfItemScale(this.ntfAniParameters),
        y: NotificationUtils.getNtfItemScale(this.ntfAniParameters)
      })
      .rotate({ x: 1, angle: NotificationUtils.getNtfItemRotateAngle(this.ntfAniParameters) })
      .enabled(this.ntfAniParameters?.isItemEnable() ?? true)
    }
  }

  @Builder
  buildExtraContent() {
    Column() {
      Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
        this.buildIcons()
        this.buildContent()
      }
      .bgBrightnessStyle()
      .padding({
        left: $r('app.float.ntf_item_padding_start_end'),
        right: $r('app.float.ntf_item_padding_start_end'),
      })
    }
    .onClick(this.onClickCB)
    .accessibilityDescription(AccessUtil.getSwipeDescription(this.isAccessibilityMode, this.translateX !== 0))
    .borderRadius($r('app.float.ntf_list_content_border_radius'))
    .shadow(this.itemStyle.shadow)
    .clip(true)
    .useEffect(true)
    .translate({ x: this.translateX })
    .gesture(PanGesture({
      direction: PanDirection.Horizontal,
      distance: NtfItemSwipeController.SWIPE_DISTANCE
    }).onActionStart((event?: GestureEvent) => this.handleActionStart(event))
      .onActionUpdate((event?: GestureEvent) => this.handleActionUpdate(event))
      .onActionEnd((event?: GestureEvent) => this.handleActionEnd(event))
      .onActionCancel(() => this.handleActionCancel())
    )
    .onAreaChange((oldValue: Area, newValue: Area) => {
      this.itemArea = newValue;
      this.swipeController?.setItemWidth(newValue.width as number);
    })
  }

  @Builder
  buildMenu() {
    // 左滑menu按钮
    NotificationExtraMenuRow({ swipeController: this.swipeController })
      .onSizeChange((oldValue: SizeOptions, newArea: SizeOptions) => {
        this.menuWidth = newArea.width as number;
      })
      .clip(new Path(this.swipeController.buildMenuClipRect ?
        {
          commands: this.swipeController?.buildMenuClipRect(
            this.menuWidth,
            this.translateX,
            this.itemArea ? this.itemArea.height : 0
          )
        }
        : {}))
  }

  @Builder
  buildIcons() {
    Stack({ alignContent: Alignment.Start }) {
      ForEach(this.getExtraNtfAppList().slice(0, Math.min(3, this.getExtraNtfAppList().length)),
        (entry: NotificationEntry) => {
          if (entry.overlayIconStyle !== OverlayIconStyle.REVERSE) {
            this.buildSingleIcon(entry)
          } else {
            Stack() {
              Image(entry.getAppIcon(true))
                .id(entry.hashCode + '_image_app_icon')
                .attributeModifier(new NtfAppIconModifier($r('app.float.ntf_small_icon_size_phone'),
                  $r('app.float.ntf_item_right_icon_radius'), undefined, false))
              DeliverBadge({
                isKgScene: this.notificationType === NotificationType.TYPE_PHONE_KEYGUARD,
              })
            }
            .zIndex(this.getZIndex(entry))
            .translate({ x: this.getStartMargin(this.getNtfIndex(entry)) })
            .animation({ curve: NtfAnimationConsts.EXTRA_NTF_EXPAND_CURVE })
            .transition(this.iconTranEffectArrays[this.getNtfIndex(entry)])
          }
        }, (entry: NotificationEntry, index: number): string => { // 请勿删除index，否则数组元素的下标发生变化是，会导致数组元素（组件）重新创建。
          return entry.getGroupTypeKey() + this.forceRefreshFlag;
        })
    }
    .width(this.getIconWidth())
    .flexShrink(0)
    .flexGrow(1)
    .renderGroup(true)
  }

  @Builder
  buildSingleIcon(entry: NotificationEntry) {
    Image(entry.getAppIcon(true))
      .id(entry.hashCode + '_image_app_icon')
      .attributeModifier(new NtfAppIconModifier($r('app.float.ntf_small_icon_size_phone'),
        $r('app.float.ntf_item_right_icon_radius'), undefined, false))
    .zIndex(this.getZIndex(entry))
    .translate({ x: this.getStartMargin(this.getNtfIndex(entry)) })
    .animation({ curve: NtfAnimationConsts.EXTRA_NTF_EXPAND_CURVE })
    .transition(this.iconTranEffectArrays[this.getNtfIndex(entry)])
  }

  @Builder
  buildContent() {
    Column() {
      AccessibilityCollapsedState({
        state: ResUtils.getInnerString($r('app.string.cc_accessibility_str_ntf_swipe_right_text')),
        isAccessibilityMode: this.isAccessibilityMode
      })
      Row() {
        Text($r('app.string.ntf_extra_message_brief_title'))
          .fontSize($r('app.float.ntf_title_font_size'))
          .fontWeight(FontWeight.Medium)
          .fontColor($r('app.color.theme_ntf_color_text_primary'))
          .fontFeature('\"ss08\" on')
          .maxFontScale(2)
          .constraintSize({
            minHeight: $r('app.float.ntf_extra_brief_title_lineHeight')
          })
          .maxLines(NotificationConfig.ITEM_CONTENT_SINGLE_LINE)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .draggable(false)
          .flexShrink(1)
          .transition(this.textTranEffect)
          .renderGroup(true)
          .margin({ end: LengthMetrics.resource($r('app.float.ntf_item_padding_start_end')) })

        this.buildTimestamp();
      }
      .margin({
        bottom: $r('app.float.ntf_extra_brief_header_margin_bottom')
      })
      .width('100%')
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.SpaceBetween)

      Text($r('app.string.ntf_extra_message_brief_content', this.contentBrief))
        .draggable(false)
        .id(`${TAG}_Brief_Content`)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .fontWeight(FontWeight.Regular)
        .fontSize($r('app.float.ntf_title_font_size'))
        .maxFontScale(2)
        .fontFeature('\"ss08\" on')
        .fontColor(this.colorModeVM?.themeFontForegroundColor)
        .foregroundBrightness(this.colorModeVM?.themeFontForegroundBrightnessOptions)
        .constraintSize({
          minHeight: $r('app.float.ntf_text_line_height')
        })
        .textAlign(TextAlign.Start)
        .transition(this.textTranEffect)
        .renderGroup(true)
    }
    .padding({ start: LengthMetrics.resource($r('app.float.ntf_item_padding_start_end')) })
    .margin({
      bottom: $r('app.float.ntf_extra_brief_main_margin_bottom'),
      top: $r('app.float.ntf_extra_brief_main_margin_top')
    })
    .flexBasis('auto')
    .alignItems(HorizontalAlign.Start)
  }

  private isNeedUpdateContentBrief(): boolean {
    const curSysLanguage = i18n.System.getSystemLanguage();
    if (curSysLanguage !== this.recordedSysLanguage) {
      this.recordedSysLanguage = curSysLanguage;
      return true;
    }
    return false;
  }

  private handleActionStart(event?: GestureEvent) {
    if (this.swipeHashCode !== '') {
      return;
    }
    this.swipeHashCode = this.hashCode;
    this.ntfExtraGroupBriefScale = 1;
    this.isRTL = RTLUtil.isRTL();
    // 记录起始位移
    this.startTranX = this.translateX;
  }

  private handleActionUpdate(event?: GestureEvent) {
    if (!event || this.swipeHashCode !== this.hashCode) {
      return;
    }
    this.translateX = this.startTranX + event.offsetX;
  }

  private getRTLValue(value:number): number {
    let mark = this.isRTL ? -1 : 1
    return mark * value;
  }

  private handleActionEnd(event?: GestureEvent) {
    if (!event || this.swipeHashCode !== this.hashCode) {
      return;
    }
    this.swipeHashCode = '';
    let endTranX = 0;
    if (this.getRTLValue(this.translateX) >= 0) {
      endTranX = 0;
    } else if (this.getRTLValue(this.startTranX) < 0) {
      endTranX = (this.menuWidth - Math.abs(this.translateX)) > SWIPE_LEFT_CRITICAL ? 0
        : this.getRTLValue(-this.menuWidth);
    } else {
      endTranX = Math.abs(this.translateX) > SWIPE_LEFT_CRITICAL ? this.getRTLValue(-this.menuWidth) : 0;
    }
    animateTo(SWIPE_ANIM, () => {
      this.translateX = endTranX;
    })
    AccessUtil.sendNtfSwipeAccessibility(event.offsetX);
  }

  private handleActionCancel() {
    if (this.swipeHashCode !== this.hashCode) {
      return;
    }
    this.swipeHashCode = '';
    let endTranX = 0;
    if (this.getRTLValue(this.translateX) >= 0) {
      endTranX = 0;
    } else if (this.getRTLValue(this.startTranX) < 0) {
      endTranX = (this.menuWidth - Math.abs(this.translateX)) > SWIPE_LEFT_CRITICAL ? 0
        : this.getRTLValue(-this.menuWidth);
    } else {
      endTranX = Math.abs(this.translateX) > SWIPE_LEFT_CRITICAL ? this.getRTLValue(-this.menuWidth) : 0;
    }
    animateTo(SWIPE_ANIM, () => {
      this.translateX = endTranX;
    })
  }

  onSwipeIdChange() {
    log.showDebug(`onSwipeIdChange: ${this.swipeHashCode}`);
    if (this.hashCode !== this.swipeHashCode && this.swipeHashCode !== '') {
      this.updateItemTranxWithAnim(0);
      this.onUpdateItemTranX(this.translateX, false);
    }
  }

  /**
   * 更新通知条目横向平移距离
   * SwipeCallback
   *
   * @param tranX 平移距离
   * @param isRemoveEntry 是否移除通知
   */
  onUpdateItemTranX(tranX: number, isRemoveEntry: boolean): void {
    this.clipTranslateAnimator?.pause();
    this.updateItemTranx(tranX);
  }

  /**
   * 更新通知条目横向平移动画
   * SwipeCallback
   *
   * @param itemAnim 动画
   */
  onUpdateItemAnim(itemAnim: AnimateParam): void {
    this.itemTranAnim = itemAnim;
  }

  private updateItemTranxWithAnim(tranX: number): void {
    if (this.itemTranAnim == null) {
      animateTo(SWIPE_ANIM, () => {
        this.translateX = tranX;
      })
    } else {
      animateTo(this.itemTranAnim, () => {
        this.translateX = tranX;
      })
    }
  }

  /**
   * 面板触摸事件down点变化
   */
  private onGlobalDownYChange(): void {
    if (this.panelDownGlobalY == -1 ||
    CommonUtils.isInvalid(this.itemArea)) {
      return;
    }
    // 横滑展开状态，down点不在条目区域内，则收起横滑状态
    let itemTop = (this.itemArea as Area).globalPosition.y as number;
    let itemBottom = ((this.itemArea as Area).height as number) + itemTop;
    if (this.panelDownGlobalY < itemTop || this.panelDownGlobalY > itemBottom) {
      this.updateItemTranxWithAnim(0);
    }
  }

  private updateItemTranx(tranX: number): void {
    // 在按钮裁剪区域内滑动使用自定义动画
    if (this.itemTranAnim != null && this.swipeController.checkIsInClipRange(tranX, this.translateX)) {
      this.onUpdateClipItemTranX(tranX);
      return;
    }
    this.updateItemTranxWithAnim(tranX);
  }

  private onUpdateClipItemTranX(tranX: number): void {
    this.clipTranslateAnimator = this.swipeController.getClipTranslateAnimation(this.translateX, tranX);
    let _this = this
    this.clipTranslateAnimator.onframe = (value: number) => {
      _this.translateX = value;
    }
    this.clipTranslateAnimator.play();
  }

  private getAppIconShadow(entry: NotificationEntry): ShadowOptions {
    let index = this.getNtfIndex(entry);
    let isShadow = (index ?? 0) < (Math.min(3, this.extraNtfList?.length ?? 0) - 1);
    return isShadow ? this.hasShadow : this.noShadow;
  }

  private onNtfListChange(): void {
    this.lastNtfEntry?.unregisterDataUpdateListener(this.ntfDataUpdateListener);
    const ntfAppList = this.getExtraNtfAppList();
    if (ntfAppList.length > 0) {
      this.lastNtfEntry = ntfAppList[ntfAppList.length - 1];
      this.lastNtfEntry.registerDataUpdateListener(this.ntfDataUpdateListener);
      this.updateBrief(ntfAppList);
    }
  }

  private updateBrief(ntfAppList?: Array<NotificationEntry>): void {
    if (!ntfAppList) {
      ntfAppList = this.getExtraNtfAppList();
    }
    if (ntfAppList.length > 0) {
      const appNameList: string[] = [];
      const template = '_+template+_';
      const templateString = ResUtils.getInnerStringNumS($r('app.string.ntf_extra_message_brief_app_tag'), template);
      const curThreshold = Math.min(NTF_EXTRA_BRIEF_COUNT_THRESHOLD, ntfAppList.length);
      for (let index = 0; index < curThreshold; index++) {
        const appName = ntfAppList[index].appName?.value ?? '';
        if (index === 0) {
          appNameList.push(appName);
        } else {
          appNameList.push(templateString + appName);
        }
      }
      this.contentBrief = appNameList.join('').replaceAll(template, '');
    }

    if (this.deliveryTime !== this.extraNtfList[0]?.deliveryTime) {
      this.deliveryTime = this.extraNtfList[0]?.deliveryTime;
      this.timeVm?.update(this.deliveryTime);
    }
  }

  private getExtraNtfAppList(): Array<NotificationEntry> {
    let extraNtfAppList: NotificationEntry[] = [];
    if (this.extraNtfList) {
      this.extraNtfList.forEach((value) => {
        if (extraNtfAppList.findIndex((ntf) => ntf.uid === value.uid) < 0) {
          extraNtfAppList.push(value);
        }
      });
    }
    return extraNtfAppList;
  }

  private getStartMargin(index: number): string {
    let unit = 'vp';
    let mark = RTLUtil.isRTL() ? -1 : 1
    return mark * (this.iconSize * index / 2 + (index === 0 ? 0 : 1)) + unit;
  }

  private getZIndex(entry: NotificationEntry): number {
    let length = this.extraNtfList ? this.getExtraNtfAppList().length : 0;
    if (length > 0) {
      return length - this.getNtfIndex(entry);
    }
    return 0;
  }

  private getIconWidth(): string {
    let length = Math.min(3, this.extraNtfList ? this.getExtraNtfAppList().length : 0);
    if (length > 0) {
      return (length > 1 ? ((length - 1) * this.iconSize / 2 + this.iconSize + 1) : this.iconSize) + 'vp';
    }
    return '0vp';
  }

  private getNtfIndex(entry: NotificationEntry): number {
    if (this.extraNtfList) {
      for (let index = 0; index < this.extraNtfList.length; index++) {
        if (entry.getGroupTypeKey() == this.extraNtfList[index]?.getGroupTypeKey()) {
          return index;
        }
      }
    }
    return 0;
  }

  private getIconTranEffectWhenCollapsed(): TransitionEffect[] {
    let tranEffectArray: TransitionEffect[] = [];
    tranEffectArray[0] = TransitionEffect.IDENTITY;
    tranEffectArray[1] = this.getOtherIconTranEffect(1);
    tranEffectArray[2] = this.getOtherIconTranEffect(2);
    return tranEffectArray;
  }

  /**
   * 更多通知折叠展开图标动效
   * 1、透明度从0变到1，耗时100ms，第二个图标延迟183ms，第三个图标延迟233ms;
   * 2、缩放从0.8变到1，第二个图标延迟183ms，耗时100ms；第三个图标延迟233ms，耗时183ms
   * 3、位移20vp，第二个图标延迟183ms，耗时183ms；第三个图标延迟233ms，耗时183ms
   *
   * @param index 图标索引
   * @returns 动效参数
   */
  private getOtherIconTranEffect(index: number): TransitionEffect {
    const delayTime = index === 2 ? 233 : 183;
    const durationTime = index === 2 ? 183 : 100;
    const appearEffect = this.isCreatedExtraBriefWhenCollapsed ? TransitionEffect.IDENTITY :
    TransitionEffect.OPACITY.animation({ duration: 100, delay: delayTime })// 透明度
      .combine(TransitionEffect.scale({ x: 0.8, y: 0.8 })// 缩放
        .animation({ duration: durationTime, delay: delayTime, curve: NtfAnimationConsts.GROUP_ITEM_EXPAND_CURVE }))
      .combine(TransitionEffect.translate({ x: NotificationUtils.getRTLValue(-20) })// 位移
        .animation({ duration: durationTime, delay: delayTime, curve: NtfAnimationConsts.GROUP_ITEM_EXPAND_CURVE }));
    return TransitionEffect.asymmetric(appearEffect, this.getIconDisappearTranEffect());
  }

  private getIconTranEffect(): TransitionEffect[] {
    let tranEffectArray: TransitionEffect[] = [];
    tranEffectArray[0] = TransitionEffect.OPACITY.animation({ duration: 116 });
    let tranEffect = this.getIconDisappearTranEffect();
    tranEffectArray[1] = tranEffect;
    tranEffectArray[2] = tranEffect;
    tranEffectArray[3] = tranEffect;
    return tranEffectArray;
  }

  private getIconDisappearTranEffect(): TransitionEffect {
    return TransitionEffect.scale({ x: 0.8, y: 0.8 })
      .animation({ duration: 116, curve: curves.cubicBezierCurve(0.2, 0, 0.2, 1) })
      .combine(TransitionEffect.OPACITY.animation({ duration: 116 }));
  }

  private getTextTranEffectWhenCollapsed(): TransitionEffect {
    const appearEffect = this.isCreatedExtraBriefWhenCollapsed ? TransitionEffect.IDENTITY :
    TransitionEffect.translate({ x: NotificationUtils.getRTLValue(-20) })
      .animation({
        delay: this.extraNtfList ? this.extraNtfCollapsedAnimation?.getFirstExtraNtfDelayTime() : 0,
        curve: NtfAnimationConsts.EXTRA_NTF_EXPAND_CURVE
      });
    return TransitionEffect.asymmetric(appearEffect, this.getTextTranEffect());
  }

  private getTextTranEffect(): TransitionEffect {
    return TransitionEffect.OPACITY.animation({ duration: 116 });
  }
}