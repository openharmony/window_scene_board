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

import { NotificationEntry } from '../../model/NotificationEntry';
import { NotificationType } from '../../common/NotificationType';
import { NotificationConfig } from '../../common/NotificationConfig';
import { NtfHeaderVM } from '../../vm/NtfHeaderVM';
import { NtfPcCloseVM } from '../../vm/NtfPcCloseVM';
import { LogDomain, LogHelper, CommonUtils, ArrayUtils } from '@ohos/basicutils';
import { RTLUtil } from '@ohos/componenthelper';
import { DeviceHelper, EventManager, EvtBus, HiDfxEventUtil, } from '@ohos/frameworkwrapper';
import { ResUtils } from '@ohos/windowscene';
import { DateTimeView } from '@ohos/customcomponent/src/main/ets/pages/DateTimeView';
import NTF_LIST_VM_HOLDER from '../../model/NtfListVmHolder';
import curves from '@ohos.curves';
import { ScreenLockNotificationConst } from '@ohos/screenlockcommon/src/main/ets/constants/ScreenLockNotificationConstants';
import { screenLockSysFloatTipControl } from '@ohos/screenlockcommon/src/main/ets/manager/SysFloatTipController';
import { immersiveKgMgr, OverlayIconStyle } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { FontScaleState, fontScaleManager } from '@ohos/systemuicommon';
import { NtfAppIconModifier } from '../../vm/style/NtfAppIconModifier';
import { BrightnessOptionUtils } from '@ohos/systemuicommon/Index';
import { NtfColorModeVM } from '../../vm/NtfColorModeVM';
import { ntfViewConfigManager } from '../../vm/config/NtfViewConfigManager';
import { NtfListContentConfig } from '../../vm/config/NtfViewConfig';
import pinTopIcon from './PinTopIcon';
import { NtfAnimationConsts } from '../../common/NtfAnimationConsts';
import { NotificationConstants } from '../../common/NotificationConstants';
import { NtfItemSwipeController } from '../../controller/NtfItemSwipeController';
import { LengthMetrics } from '@ohos.arkui.node';
import { image } from '@kit.ImageKit';
import { NotificationGroupExpandAnimation } from '../../animation/NotificationGroupExpandAnimation';
import { NtfCloseVM } from '../../vm/NtfCloseVM';
import { NtfGroupItemModifier } from '../../model/NtfItemModifier';
import { ExtraNtfCollapseEvent } from '../../common/event/NotificationEvent';
import { AccessibilityCollapsedState } from '@ohos/systemuicommon/src/main/ets/accessibility/AccessibilityAppName';
import { NotificationCollaBadgeViewV1 } from '@ohos/systemuicommon/src/main/ets/view/NotificationCollaBadgeViewV1';

const TAG = 'NotificationHeader';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

const COMPONENT_ID_TOP_FLAG = TAG + '_Text_topFlag';
const COMPONENT_ID_NTF_ARROW = TAG + '_Image_ntfArrow';
const COMPONENT_ID_ADDITIONAL_TEXT = TAG + '_Text_Additional';

/**
 * 条目展开状态监听
 */
export type OnItemExpandListener = (isItemExpanded: boolean, isNtfWindowShow ?: boolean) => void;

/**
 * 通知头
 *
 * @since 2022-12-19
 */
@Component
export struct NotificationHeader {
  /**
   * 长辈模式字体
   */
  @State fontScaleState: FontScaleState = fontScaleManager.getSysFontScaleState();

  /**
   * 是否开启辅助功能朗读模式
   */
  @StorageProp('isAccessibilityMode') isAccessibilityMode: boolean = false;
  /**
   * 通知数据
   */
  private ntfEntry?: NotificationEntry;

  /**
   * 条目展开监听器
   */
  private itemExpandListener?: OnItemExpandListener;

  /**
   * 是否为横幅通知
   */
  private isHeadsUp: boolean = false;

  /**
   * 通知类型
   */
  @Consume notificationType: number;

  /**
   * 窗口是否可见
   */
  @Consume @Watch('onWindowShowChange') isNtfWindowShow: boolean;

  /**
   * 右上角close按钮hover状态
   */
  private isPcCloseHovered: boolean = false;

  /**
   * 当前条目是否展开，默认收起
   */
  private isItemExpanded: boolean = false;
  /**
   * 应用名称
   */
  @State appName?: ResourceStr = this.ntfEntry?.appLabel;
  /**
   * 应用图标
   */
  @State appIcon: image.PixelMap | string | Resource | undefined = undefined;

  /**
   * 是否显示摘要
   */
  @State isShowSubtext: boolean = false;

  /**
   * 通知头摘要文本
   */
  @State ntfAdditionalText: string = '';

  /**
   * 通知发送时间
   */
  @State ntfDeliveryTime: number = 0;

  /**
   * 通知是否可展开的
   */
  @State isNtfExpandable: boolean = false;

  /**
   * 通知是否置顶显示
   */
  @State isDisplayAtTop: boolean = false;

  /**
   * 通知是否处于隐藏状态，隐藏状态下不能显示展开按钮
   */
  @State isHideContent: boolean = false;

  /**
   * VM
   */
  private headerVm: NtfHeaderVM = new NtfHeaderVM();

  /**
   * 条目横滑控制器
   */
  private swipeController?: NtfItemSwipeController;

  /**
   * close按钮VM
   */
  private pcCloseVM?: NtfPcCloseVM;

  @State colorModeVM: NtfColorModeVM | undefined = undefined;

  /**
   * 简介图标距离顶部的位置
   */
  @Prop briefIconPositionY: number = 0;

  /**
   * 是否扩展新形态小外屏
   */
  @Prop isOuterHomeFolded: boolean = false;

  /**
   * 锁屏是否加锁状态
   */
  @Consume isKeyguardLock: boolean;

  private listContentConfig: NtfListContentConfig = ntfViewConfigManager.getListContentConfig();

  /**
   * 是否组通知展开
   */
  @Prop isClicked: boolean = false;
  @Consume private closeVM?: NtfCloseVM;
  groupItemModifier?: NtfGroupItemModifier = DeviceHelper.isPC() ? new NtfGroupItemModifier(this.closeVM) : undefined;

  private eventMgr: EventManager = EvtBus.createEventManager();

  aboutToAppear(): void {
    log.showInfo(`aboutToAppear`);
    // 初始化展开状态
    this.isItemExpanded = this.ntfEntry?.isItemExpanded ?? false;
    // 初始化VM
    this.headerVm?.init(this);
    // 初始化通知数据
    this.refreshNtfData();
    // 注册通知数据变化监听
    this.ntfEntry?.registerDataUpdateListener(this);
    // 监听Close按钮hover状态
    this.pcCloseVM?.registerOnPcCloseHoverChangeListener(this.ntfEntry as NotificationEntry, this);
    this.groupItemModifier?.setEntry(this.ntfEntry);
    this.eventMgr.on(ExtraNtfCollapseEvent, this.onExtraNtfCollapseEvent)
  }

  aboutToDisappear(): void {
    log.showInfo(`aboutToDisappear`);
    this.ntfEntry?.unregisterDataUpdateListener(this);
    this.pcCloseVM?.unregisterOnPcCloseHoverChangeListener(this.ntfEntry as NotificationEntry, this);
    this.headerVm?.onDestroy();
    this.eventMgr.offAll();
  }

  /**
   * close按钮hover状态变化回调
   * OnPcCloseHoverChangeListener
   *
   * @param isHover 当前hover状态
   */
  onPcCloseHoverChange(isHover: boolean): void {
    this.isPcCloseHovered = isHover;
  }

  /**
   * 通知数据变化回调
   * NtfDataUpdateListener
   *
   * @param newEntry 新通知对象
   */
  onNtfDataUpdate(newEntry: NotificationEntry): void {
    this.ntfEntry = newEntry;
    // 刷新通知数据
    this.refreshNtfData();
  }

  /**
   * 获取通知数据
   * HeaderCallback
   *
   * @return 通知数据
   */
  getNtfEntry(): NotificationEntry {
    return this.ntfEntry as NotificationEntry;
  }

  /**
   * 条目展开状态回调
   * HeaderCallback
   *
   * @param isItemExpanded 条目是否展开
   */
  onItemExpandChange(isItemExpanded: boolean): void {
  }

  /**
   * 通知头次要文本内容
   *
   * @param subtext 次要文本
   */
  onUpdateSubtext(subtext: string): void {
    this.ntfAdditionalText = subtext;
    this.isShowSubtext = this.isShowSubtext || !CommonUtils.isEmpty(subtext);
  }

  @Builder
  buildAppName() {
    Text(this.appName)
      .draggable(false)
      .id(TAG + '_appName')
      .fontSize(this.fontScaleState.getScaleSize($r('app.float.ntf_app_name_font_size')))
      .fontColor($r('app.color.theme_ntf_color_text_primary'))
      .fontWeight(FontWeight.Regular)
      .fontFeature('\"ss08\" on')
      .maxLines(NotificationConfig.LAYOUT_WEIGHT_ONE)
      .textOverflow({ overflow: TextOverflow.Ellipsis })
      .renderGroup(true)
      .margin({
        left: RTLUtil.isRTL() ? 0 : $r('app.float.ntf_header_common_margin'),
        right: RTLUtil.isRTL() ? $r('app.float.ntf_header_common_margin') : 0
      })
      .height(this.fontScaleState.getScaleSize($r('app.float.ntf_extra_brief_title_lineHeight')))
      .transition(!this.isClicked ? TransitionEffect.IDENTITY : TransitionEffect.translate({ y: 5 })
        .animation({
          duration: 333,
          curve: NtfAnimationConsts.GROUP_ITEM_EXPAND_CURVE
        }).combine(
          TransitionEffect.OPACITY.animation({
            delay: 50,
            duration: 333,
            curve: NtfAnimationConsts.GROUP_ITEM_EXPAND_CURVE
          })
        ))
  }

  @Builder
  buildSubText() {
    // 前面有应用名则显示 ·
    if (this.isShowIcon()) {
      Text($r('app.string.ntf_header_divider_symbol'))
        .draggable(false)
        .fontColor(this.colorModeVM?.themeFontForegroundColor)
        .foregroundBrightness(this.colorModeVM?.themeFontForegroundBrightnessOptions)
        .margin({
          left: $r('app.float.ntf_header_common_margin'),
          right: $r('app.float.ntf_header_common_margin')
        })
        .id(`${TAG}_Text_icon`)
    }
    Text(this.ntfAdditionalText)
      .draggable(false)
      .id(COMPONENT_ID_ADDITIONAL_TEXT)
      .fontSize($r('app.float.ntf_app_time_font_size'))
      .fontColor(this.colorModeVM?.
      themeFontForegroundColor)
      .foregroundBrightness(this.colorModeVM?.themeFontForegroundBrightnessOptions)
      .fontWeight(FontWeight.Regular)
      .textOverflow({ overflow: TextOverflow.Ellipsis })
      .maxLines(1)
      .flexShrink(0)
  }

  @Builder
  buildPinTop() {
    if (this.listContentConfig.pinTopUseSymbolGlyph) {
      pinTopIcon()
    } else {
      Text($r('app.string.topped_notification_flag')).draggable(false)
        .id(COMPONENT_ID_TOP_FLAG)
        .border({
          width: $r('app.float.ntf_pin_top_flag_border_width'),
          color: this.colorModeVM?.bgPinTextColor,
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
        .margin({ end: LengthMetrics.resource($r('app.float.ntf_header_common_margin')) })
        .flexShrink(0)
        .geometryTransition(this.getGeometryTransitionId(), this.getGeometryTransitionOptions())
        .fontColor(this.colorModeVM?.bgPinTextColor)
        .foregroundBrightness(this.colorModeVM?.themeTimestampForegroundBrightnessOptions)
    }
  }

  @Builder
  buildHeaderLabel() {

    if (this.isPc()) {
      // 通知时间
      DateTimeView({
        slot: (this.ntfEntry as NotificationEntry).isGroup
          ? (this.ntfEntry as NotificationEntry).getGroupKey()
          : (this.ntfEntry as NotificationEntry).hashCode,
        timeMillis: this.ntfDeliveryTime,
        fontSize: $r('app.float.ntf_app_name_font_size'),
        fontColor: $r('app.color.theme_ntf_color_text_primary')
      })
        .margin({
          left: (this.isShowIcon() || this.isShowSubtext) ? $r('app.float.ntf_header_common_margin') : 0,
          right: $r('app.float.ntf_header_common_margin')
        })
        .flexShrink(0)
    }

    // 填充剩余空间
    Stack()
      .flexBasis(1)
      .flexGrow(1)
      .flexShrink(1)

    // 置顶标识
    if (this.isDisplayAtTop && this.isShowAppIcon()) {
      this.buildPinTop()
    }
  }

  @Builder
  buildAppIcon() {
    Image(this.appIcon)
      .id(this.ntfEntry?.getGroupTypeKey() + '_HeaderAppIcon')
      .opacity(undefined)
      .attributeModifier(new NtfAppIconModifier($r('app.float.ntf_small_icon_size_in_tint'), undefined, this.ntfEntry, false))
      .geometryTransition(this.notificationType === NotificationType.TYPE_PHONE_KEYGUARD ? '' :
        this.ntfEntry?.getGroupTypeKey() + '_' + this.notificationType + '_AppIcon',
        { hierarchyStrategy: TransitionHierarchyStrategy.NONE })
      .transition(this.checkAnimState() ? undefined : NotificationGroupExpandAnimation.getIconTransEffect(true,
        this.briefIconPositionY))
  }

  @Builder
  buildIcon() {
    if (this.ntfEntry?.overlayIconStyle !== OverlayIconStyle.REVERSE && !this.ntfEntry?.isCollaNotification) {
      this.buildAppIcon()
    } else {
      this.buildOverlayAppIcon()
    }
  }

  @Builder
  buildOverlayAppIcon() {
    Stack() {
      this.buildAppIcon()
      if(this.ntfEntry?.isCollaNotification) {
        // 全场景通知，组通知展开时仅组通知头显示设备来源
        NotificationCollaBadgeViewV1({
          geometryTransitionId : this.notificationType === NotificationType.TYPE_PHONE_KEYGUARD ? '' :
            this.ntfEntry?.getGroupTypeKey() + '_' + this.notificationType + '_CollaBadge'
        })
      }
    }
  }

  @Builder
  buildNormalHeader() {
    Row() {
      Flex({
        direction: FlexDirection.Row,
        alignItems: ItemAlign.Center,
        justifyContent: FlexAlign.Start
      }) {
        if (this.isShowIcon()) {
          // 图标
          this.buildIcon();
          
          AccessibilityCollapsedState({
            state: ResUtils.getInnerString($r('app.string.cc_accessibility_str_ntf_swipe_left_text')),
            isAccessibilityMode: this.isAccessibilityMode
          })
 
          this.buildAppName();

        }
        // 次要内容，下载模板有定制
        if (this.isShowSubtext) {
          this.buildSubText()
        }

        this.buildHeaderLabel()
      }
      // 占比挤占
      .layoutWeight(NotificationConfig.LAYOUT_WEIGHT_ONE)

      // 展开/收起按钮
      if (this.canExpanded()) {
        Image($r('app.media.ic_ntf_arrow_up'))
          .id(COMPONENT_ID_NTF_ARROW)
          .objectFit(ImageFit.Fill)
          .hitTestBehavior(HitTestMode.None)
          .width($r('app.float.ntf_arrow_width'))
          .height($r('app.float.ntf_arrow_height'))
          .fillColor(this.colorModeVM?.ntfThemeTextSecondaryColor)
          .opacity(NotificationConfig.NTF_ARROW_ICON_ALPHA)
          .transition(!this.isClicked ? TransitionEffect.IDENTITY : TransitionEffect.translate({ y: 5 })
            .animation({
              delay: 50,
              duration: 100,
              curve: curves.cubicBezierCurve(0.20, 0.00, 0.20, 1.0)
            }))
      }
    }
    .id(TAG + '_' + this.ntfEntry?.getGroupTypeKey())
    .width('100%')
    .padding({
      left: $r('app.float.ntf_item_padding_start_end'),
      right: $r('app.float.ntf_item_padding_start_end'),
      top: $r('app.float.ntf_small_icon_offset_phone'),
      bottom: $r('app.float.ntf_header_common_margin')
    })
    // 可展开时通知头才响应点击事件
    .onClick(() => {
      if (NotificationType.isKeyguard(this.notificationType)) {
        this.onNtfHeaderClick();
      } else {
        // 组通知展开收起动效延迟响应，保证卡片回弹动效优先下发，减少组通知展开收起场景响应时延
        setTimeout(() => {
          this.onNtfHeaderClick();
        }, 10);
      }
    })
    .focusable(false)
    .attributeModifier(this.groupItemModifier)
    .alignItems(VerticalAlign.Center)
  }

  build() {
    if (!CommonUtils.isInvalid(this.ntfEntry)) {
      if (NotificationType.isKeyguard(this.notificationType)) {
        Stack() {
          this.buildNormalHeader();
          Column()
            .width('100%')
            .height($r('app.float.ntf_item_header_height'))
            .visibility(this.isKeyguardLock ? Visibility.Visible : Visibility.None)
            .onGestureJudgeBegin((info) => {
              return this.swipeController?.onGestureJudgeBegin(this.notificationType, info);
            })
            .gesture(GestureGroup(GestureMode.Exclusive,
              TapGesture({ count: 2 }).onAction(() => this.onNtfHeaderClick(2)),
              TapGesture({ count: 1 }).onAction(() => this.onNtfHeaderClick())))
        }
      } else {
        this.buildNormalHeader();
      }
    }
  }

  /**
   * 是否可以展开
   */
  private canExpanded(): boolean {
    return this.isNtfExpandable && !this.isHideContent;
  }

  /**
   * 刷新通知相关数据
   */
  private refreshNtfData(): void {
    // 通知头次要文本
    this.headerVm?.refreshSubtext();
    if (this.ntfEntry) {
      // 通知发送时间
      this.ntfDeliveryTime = this.ntfEntry?.deliveryTime;
      // 通知是否可展开，横幅通知的按钮默认显示，非横幅通知的按钮才需要展开
      this.isNtfExpandable = this.ntfEntry?.isExpandable ||
        (!this.isHeadsUp && !ArrayUtils.isEmpty(this.ntfEntry.actionButtons));
      // 通知是否置顶显示
      this.isDisplayAtTop = this.ntfEntry?.isDisplayAtTop;
      this.appName = this.ntfEntry.appLabel;
      this.appIcon = this.ntfEntry?.getAppIcon(this.isUseAppIcon());
      log.showInfo(`refreshNtfData this.ntfDeliveryTime = ${this.ntfDeliveryTime},
      this.isDisplayAtTop = ${this.isDisplayAtTop}`);
    }
  }

  /**
   * 是否只使用应用图标
   *
   * @return true只使用应用图标
   */
  private isUseAppIcon(): boolean {
    if (CommonUtils.isInvalid(this.ntfEntry)) {
      return false;
    }
    return (this.ntfEntry as NotificationEntry).isGroup;
  }

  /**
   * 条目重置展开状态事件
   */
  private onWindowShowChange(): void {
    // 面板可见不处理
    if (this.isNtfWindowShow) {
      return;
    }
    // 重置展开状态
    this.refreshItemExpandState(false, this.isNtfWindowShow);
  }

  /**
   * 通知头点击事件处理
   */
  private onNtfHeaderClick = (clickCount: number = 1): void => {
    log.showInfo('onNtfHeaderClick: ' + this.ntfEntry?.toSimpleString());
    if (!this.isNtfExpandable) {
      return;
    }
    // 锁屏场景点击检测
    if (this.kgCheckClickTip(clickCount)) {
      return;
    }
    this.refreshItemExpandState(false);

    if (this.ntfEntry?.isGroup) {
      HiDfxEventUtil.reportNtfGroupExpandClick(this.ntfEntry?.creatorBundleName, !this.isItemExpanded);
    }
  }

  /**
   * 刷新条目展开状态（非横幅通知）
   *
   * @param isItemExpanded 最新展开状态
   */
  private refreshItemExpandState(isItemExpanded: boolean, isNtfWindowShow?: boolean): void {
    // 展开/折叠状态更新
    if (this.isNtfExpandable) {
      this.isItemExpanded = isItemExpanded;
      (this.ntfEntry as NotificationEntry).isItemExpanded = isItemExpanded;
      if (!CommonUtils.isInvalid(this.itemExpandListener)) {
        (this.itemExpandListener as OnItemExpandListener)(isItemExpanded, isNtfWindowShow);
      }
    }
  }

  /**
   * 当前是否为PC类型
   *
   * @return true PC面板
   */
  private isPc(): boolean {
    return NotificationType.isPc(this.notificationType);
  }

  /**
   * 是否显示图标、应用名
   *
   * @return true 显示
   */
  private isShowIcon(): boolean {
    if (CommonUtils.isInvalid(this.ntfEntry)) {
      return false;
    }
    // 组通知头显示图标，横幅通知显示图标
    if ((this.ntfEntry as NotificationEntry).isGroup || this.isHeadsUp) {
      return true;
    }
    // child通知独一个时显示图标
    return this.getGroupEntry()?.getChildrenSize() === 1;
  }

  private isShowAppIcon() : boolean {
    if (CommonUtils.isInvalid(this.ntfEntry)) {
      return false;
    }
    // 组通知头显示图标，横幅通知显示图标
    if ((this.ntfEntry as NotificationEntry).isGroup || this.isHeadsUp) {
      return true;
    }
    // child通知独一个时显示图标
    return this.getGroupEntry()?.getChildrenSize() === 1;
  }

  /**
   * 获取组通知实例
   * 背景：子通知实例为全局共享，组通知实例与VM实例个数一直，子通知中对应的组通知实例可能与VM中的组通知实例不一致
   * 该方法用于保证组通知和子通知的对应关系
   *
   * @return 组通知实例
   */
  getGroupEntry(): NotificationEntry {
    const vmHolder = NTF_LIST_VM_HOLDER.getNtfListVmInstance(this.notificationType);
    let group: NotificationEntry = vmHolder?.getGroupEntry((this.ntfEntry as NotificationEntry).getGroupKey());
    if (CommonUtils.isInvalid(group)) {
      return (this.ntfEntry as NotificationEntry)?.groupEntry!;
    }
    return group;
  }

  /**
   * 锁屏通知点击发出弹窗提醒检测
   *
   * @param clickCount 点击计数值, 区分单双击
   * @returns 是否发出弹窗提醒
   */
  private kgCheckClickTip(clickCount: number): boolean {
    if (!NotificationType.isKeyguard(this.notificationType)) {
      return false;
    }
    if (this.isAccessibilityMode) {
      log.showInfo('click keyguard group header in accessibility mode');
      return false;
    }
    if (clickCount === ScreenLockNotificationConst.NTF_FIRST_CLICK && this.isKeyguardLock) {
      // 若处于侧滑状态，则不弹出通知且收起侧滑
      if (this.swipeController?.isSwipeExpand()) {
        return false;
      }
      screenLockSysFloatTipControl.setTipMessage(ScreenLockNotificationConst.NTF_KEY_GUARD_TIP,
        ResUtils.getInnerStringByName(ScreenLockNotificationConst.DOUBLE_CLICK_COLLAPSE_TIP));
      screenLockSysFloatTipControl.setFloatTipDialogVisible(ScreenLockNotificationConst.NTF_KEY_GUARD_TIP, true,
        ScreenLockNotificationConst.CLICK_TOAST_SHOW_DURATION);
      return true;
    }
    screenLockSysFloatTipControl.setFloatTipDialogVisible(ScreenLockNotificationConst.NTF_KEY_GUARD_TIP, false);
    return false;
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

  private checkAnimState(): boolean {
    return !this.isClicked || this.notificationType !== NotificationType.TYPE_PHONE_KEYGUARD;
  }

  private onExtraNtfCollapseEvent = (event: ExtraNtfCollapseEvent) => {
    if (this.ntfEntry?.isExtraContentType()) {
      this.onNtfHeaderClick(ScreenLockNotificationConst.NTF_SECOND_CLICK);
    }
  };
}