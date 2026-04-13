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

import { NotificationEntry } from '../../model/NotificationEntry';
import { NotificationConfig } from '../../common/NotificationConfig';
import { NotificationType } from '../../common/NotificationType';
import { KeyguardNtfActionVM } from '../../vm/KeyguardNtfActionVM';
import { NtfActionVM } from '../../vm/NtfActionVM';
import { fontScaleManager,
  FontScaleState,
  NotificationAction,
  NotificationSysEventReporter,
} from '@ohos/systemuicommon';
import { BrightnessOptionUtils } from '@ohos/systemuicommon/Index';
import { CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { RTLUtil } from '@ohos/componenthelper';
import { HiDfxEventUtil, DeviceHelper } from '@ohos/frameworkwrapper';
import { ResUtils, SCBSceneSessionManager, FocusChangeReason } from '@ohos/windowscene';
import { NtfColorModeVM } from '../../vm/NtfColorModeVM';
import { NotificationUtils } from '../../common/NotificationUtils';
import { NtfSingleItemVM } from '../../vm/NtfSingleItemVM';
import { ntfViewConfigManager } from '../../vm/config/NtfViewConfigManager';
import { NotificationUtil } from '@ohos/systemuicommon/newTsIndex';
import { NtfHeadsUpVM } from '../../vm/NtfHeadsUpVM';

const TAG = 'NotificationActionView';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

const COMPONENT_ID_TEXT = TAG + '-ActionReply_TextInput_text';
const COMPONENT_ID_SEND = TAG + '-ActionReply_Image_send';
const COMPONENT_ID_ACTION_TITLE = TAG + '-ActionButton_Text_title';
const ACTION_BUTTON_OPACITY_AOD = 0.1;
const ACTION_DIVIDER_OPACITY_AOD = 0.1;
/**
 * 通知action按钮
 *
 * @since 2022-12-22
 */
@Component
export struct NotificationActionView {
  /**
   * 通知数据
   */
  @Consume ntfEntry: NotificationEntry;

  private ntfItemVM?: NtfSingleItemVM;

  /**
   * 横幅VM
   */
  public headsUpVM?: NtfHeadsUpVM;

  /**
   * 通知面板类型
   */
  @Consume notificationType: number;

  /**
   * 条目是否展开
   */
  @Consume @Watch('onItemExpandChange') isItemExpanded: boolean;

  @Prop isHeadsUp: boolean = false;

  /**
   * 当前正在输入的action索引
   */
  @State inputActionIndex: number = -1;

  /**
   * 通知action按钮集
   */
  @State ntfActionList: Array<NotificationAction> = [];

  @State colorModeVM: NtfColorModeVM | undefined = undefined;

  @State currActIndex: number = -1;

  private radius: BorderRadiuses = { topLeft: 0, topRight: 0, bottomLeft: 0, bottomRight: 0 };

  /**
   * VM
   */
  private actionVM: NtfActionVM | undefined = undefined;

  private isInGroup: boolean = false;

  private isInAggregate: boolean = false;

  /**
   * 下拉DropBar是否可见
   */
  private isDropBarVisible: boolean = false;

  @Prop isNeedPanelInScreenLock: boolean = false;
  @Prop isLockScreen: boolean = false;

  persistentId: number = 0;

  aboutToAppear(): void {
    this.initNtfActionVM();
    this.actionVM?.init(this, this.ntfItemVM);
    // 初始化通知数据
    this.refreshNtfData();
    // 注册数据刷新
    this.ntfEntry?.registerDataUpdateListener(this);
  }

  aboutToDisappear(): void {
    this.ntfEntry?.unregisterDataUpdateListener(this);
    this.actionVM?.onDestroy();
  }

  /**
   * 初始化 actionVM
   */
  private initNtfActionVM() {
    if (NotificationType.isKeyguard(this.getNtfType())) {
      this.actionVM = new KeyguardNtfActionVM();
    } else {
      this.actionVM = new NtfActionVM();
    }
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
   * ActionCallback
   *
   * @return 通知数据
   */
  getNtfEntry(): NotificationEntry {
    return this.ntfEntry;
  }

  isNtfKeyguard(): boolean {
    return this.isNeedPanelInScreenLock && this.isLockScreen;
  }

  /**
   * 获取通知面板类型
   * ActionCallback
   *
   * @return 通知面板类型
   */
  getNtfType(): number {
    return this.notificationType;
  }

  /**
   * 是否为横幅通知
   *
   * @returns 通知类型
   */
  isHeadsUpNtf(): boolean {
    return this.isHeadsUp;
  }

  @Builder
  buildDivider(index: number) {
    if (index !== 0) {
      Divider()
        .vertical(true)
        .height($r('app.float.ntf_buttons_divier_height'))
        .color(this.getDividerColor(index))
        .opacity(this.getDividerOpacity())
        .foregroundBrightness(this.colorModeVM?.themeForegroundDividerOption)
        .flexShrink(0)
        .margin({ bottom: this.isDropBarVisible ? ResUtils.getNumber($r('app.float.ntf_has_drop_bar_add_height')) : 0 })
    }
  }

  build() {
    Row() {
      // 回复input显示
      if (this.isInputting()) {
        ActionReply({
          onClickEvent: (text: string) => {
            let action = this.ntfEntry.actionButtons[this.inputActionIndex];
            if (this.ntfEntry) {
              if (this.isHeadsUp) {
                this.ntfEntry.notifyOutChanged();
              }
              this.ntfEntry.isHeadsUpStick = false;
            }
            HiDfxEventUtil.reportNotificationReplySend(this.ntfEntry.creatorBundleName, this.ntfEntry.id);
            this.actionVM?.startNtfAction(action, false, this.isHeadsUp, text);
          }
        })
          .margin({
            top: $r('app.float.ntf_action_send_margin_top'),
            bottom: $r('app.float.ntf_action_send_margin_bottom')
          })
          .padding({
            left: $r('app.float.ntf_action_send_padding_start_end'),
            right: $r('app.float.ntf_action_send_padding_start_end')
          })
      } else { // 按钮显示
        ForEach(this.ntfActionList, (action: NotificationAction, index: number) => {
          this.buildDivider(index);
          ActionButton({
            action: action,
            isDropBarVisible: this.isDropBarVisible,
            radius: this.getRadius(index),
            colorModeVM: this.colorModeVM,
            onClickEvent: (clickEvent?: ClickEvent) => this.onClickEvent(action, index),
            onPressOrHover: (isPressedOrHovered: boolean) => {
              if (isPressedOrHovered) {
                this.currActIndex = index;
              } else {
                this.currActIndex = -1;
              }
            }
          })
        }, (action: NotificationAction) => `${action?.actionTitle}_${action?.getUpdateCount()}`)
      }
    }
    .justifyContent(FlexAlign.SpaceAround)
    .backgroundColor(this.getActionViewBackgroundColor())
    .backgroundBrightnessInternal(this.getActionViewBackgroundBrightness())
    .width('100%')
    .borderRadius({
      bottomLeft: this.radius.bottomLeft,
      bottomRight: this.radius.bottomRight
    })
  }

  getRadius(index: number): BorderRadiuses {
    if (RTLUtil.isRTL()) {
      return {
        bottomLeft: index === this.ntfActionList.length - 1 ? this.radius.bottomRight : 0,
        bottomRight: index === 0 ? this.radius.bottomLeft : 0
      }
    } else {
      return {
        bottomLeft: index === 0 ? this.radius.bottomLeft : 0,
        bottomRight: index === this.ntfActionList.length - 1 ? this.radius.bottomRight : 0
      }
    }
  }

  private getDividerColor(index: number): Resource | ResourceColor | undefined {
    return this.currActIndex === index || this.currActIndex + 1 === index
        ? Color.Transparent
        : this.colorModeVM?.themeActionDividerColor;
  }

  private getDividerOpacity(): number {
    return 1;
  }

  private getActionViewBackgroundBrightness(): BrightnessOptions | undefined {
    return this.colorModeVM?.themeButtonBgBrightnessOptions;
  }

  private getActionViewBackgroundColor(): number | ResourceColor | undefined {
    return this.colorModeVM?.themeButtonBgColor;
  }

  private onClickEvent(action: NotificationAction, index?: number): void {
    if (this.persistentId != 0) {
      SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(this.persistentId)?.setFocusable(true);
      SCBSceneSessionManager.getInstance().requestFocus(this.persistentId, true, FocusChangeReason.CLICK);
    }
    // 存在input
    if (!CommonUtils.isEmpty(action.userInputKey)) {
      if (index != undefined) {
        this.inputActionIndex = index;
      }
      if (this.ntfEntry) {
        this.ntfEntry.isHeadsUpStick = true;
      }
      HiDfxEventUtil.reportNotificationReplyClick(this.ntfEntry.creatorBundleName, this.ntfEntry.id);
    } else { // 不存在input，直接send wantAgent
      this.ntfEntry?.notifyOutChanged();
      if (this.ntfEntry?.isCollaNotification) {
        const DISTRIBUTE_OPERATION_BUTTON = 1;
        NotificationUtil.distributeOperation(this.ntfEntry?.hashCode, DISTRIBUTE_OPERATION_BUTTON,
          index, action.actionTitle, action.userInputKey);
        log.showInfo(`click CollaNotification nft:${this.ntfEntry?.hashCode},  buttonIndex:${index}`);
        this.headsUpVM?.removeEntry(this.ntfEntry);
      } else {
        this.actionVM?.startNtfAction(action, true, this.isHeadsUp);
      }
      HiDfxEventUtil.reportNotificationButtonClick(this.ntfEntry.creatorBundleName, this.ntfEntry.id,
        this.ntfEntry.hashCode);
      NotificationSysEventReporter.notificationClickButton({
        DISPLAY_SCENE: this.isHeadsUp
          ? 3
          : NotificationType.isKeyguard(this.getNtfType())
            ? 2
            : 4,
        IS_LIVE: 1,
        CREATOR_BUNDLE_NAME: this.ntfEntry?.creatorBundleName,
        NOTIFICATION_ID: this.ntfEntry?.id,
        NOTIFICATION_SLOT_TYPE: this.ntfEntry?.slotType,
        TIME_STAMP: NotificationUtils.getNtfTimeStampByType(this.notificationType),
        BUTTON_INDEX: index,
        IS_IN_GROUP: this.isInGroup ? 1 : 0,
        IS_IN_AGGREGATE: this.isInAggregate ? 1 : 0,
        NOTIFICATION_CONTROL_FLAGS: this.ntfEntry?.controlConfig?.flags,
        TRACE_ID: this.ntfEntry?.traceId
      });
    }
  }

  /**
   * 刷新通知数据
   */
  private refreshNtfData(): void {
    // tv不支持回复按钮,tv的isSupportReplyButton为false
    if (!ntfViewConfigManager.getListContentConfig().isSupportReplyButton &&
      this.ntfEntry?.actionButtons?.length! > 0) {
      this.ntfEntry.actionButtons = this.ntfEntry?.actionButtons?.filter(item => CommonUtils.isEmpty(item.userInputKey))
    }
    // action按钮列表，PHONE最多显示2个按钮， PC最多显示3个可配置
    let size = Math.min(this.ntfEntry?.actionButtons?.length ?? 0,
      ntfViewConfigManager.getListContentConfig().buttonMaxShowSize);
    this.ntfActionList = this.ntfEntry?.actionButtons?.slice(0, size)!;
  }

  /**
   * 条目展开状态切换
   */
  private onItemExpandChange(): void {
    // 条目收起时，恢复按钮显示
    if (!this.isItemExpanded) {
      this.inputActionIndex = -1;
      if (this.ntfEntry) {
        this.ntfEntry.isHeadsUpStick = false;
      }
    }
  }

  /**
   * 是否正在输入
   */
  private isInputting(): boolean {
    return this.inputActionIndex != -1;
  }
}

@Component
struct ActionReply {
  /**
   * 长辈模式字体
   */
  @State fontScaleState: FontScaleState = fontScaleManager.getSysFontScaleState();

  /**
   * 通知数据
   */
  @Consume ntfEntry: NotificationEntry;

  /**
   * 发送点击事件
   */
  private onClickEvent: ((inputText: string) => void) | null = null;

  /**
   * 输入文本
   */
  @State inputText: string = '';

  /**
   * 是否正在发送
   */
  @State isSending: boolean = false;

  private hasReportHiEvent: boolean = false;

  build() {
    Row() {
      TextInput({ placeholder: $r('app.string.place_holder_input_content') }).draggable(false)
        .id(COMPONENT_ID_TEXT)
        .type(InputType.Normal)
        .enterKeyType(EnterKeyType.Send)
        .height(this.fontScaleState.getScaleSize($r('app.float.ntf_item_header_height')))
        .enabled(this.isSending ? false : true)
        .layoutWeight(NotificationConfig.LAYOUT_WEIGHT_ONE)
        .margin({
          right: $r('app.float.ntf_action_edit_margin_right')
        })
        .onChange((value: string) => {
          this.inputText = value;
          if (!this.hasReportHiEvent) {
            this.hasReportHiEvent = true;
            HiDfxEventUtil.reportNotificationReplyInputContent(this.ntfEntry.creatorBundleName, this.ntfEntry.id);
          }
        })
      Image($r('app.media.ic_ntf_action_send')).draggable(false)
        .id(COMPONENT_ID_SEND)
        .objectFit(ImageFit.Contain)
        .width($r('app.float.ntf_action_send_icon_size'))
        .height($r('app.float.ntf_action_send_icon_size'))
        .fillColor(this.inputText.length == 0 ? $r('app.color.ntf_action_send_disable_color') :
          $r('app.color.ntf_action_send_color'))
        .onClick(() => {
          this.isSending = true;
          if (!CommonUtils.isInvalid(this.onClickEvent)) {
            if (this.onClickEvent) {
              this.onClickEvent(this.inputText);
            }
          }
        })
    }
    .width('100%')
  }
}

/**
 * action按钮
 */
@Component
struct ActionButton {
  /**
   * 长辈模式字体
   */
  @State fontScaleState: FontScaleState = fontScaleManager.getSysFontScaleState();

  /**
   * action数据
   */
  private action?: NotificationAction;
  private radius: BorderRadiuses = { topLeft: 0, topRight: 0, bottomLeft: 0, bottomRight: 0 };
  /**
   * 按钮点击事件
   */
  private onClickEvent: ((clickEvent?: ClickEvent) => void) = ()=>{};
  /**
   * 回调，按钮按压或PC鼠标移上时回调
   */
  private onPressOrHover: ((isPressedOrHovered: boolean) => void) = ()=>{};

  /**
   * action是否按压或hover状态
   */
  @State @Watch('onStateChange') isPressedOrHovered: boolean = false;

  /**
   * 通知面板类型
   */
  @Consume notificationType: number;

  @State colorModeVM: NtfColorModeVM | undefined = undefined;

  /**
   * 下拉DropBar是否可见
   */
  private isDropBarVisible: boolean = false;

  onStateChange() {
    this.onPressOrHover(this.isPressedOrHovered);
  }

  build() {
    Stack({ alignContent: Alignment.Center }) {
      this.buildTextButton();
    }
    .flexShrink(1)
    .borderRadius(this.radius)
    .backgroundColor(this.getBgColor())
    .responseRegion([
      { x: 0, y: 0, width: '100%', height: '100%' },
      { x: 0, y: '100%', width: '100%', height: $r('app.float.ntf_action_button_response_region_height') }
    ])
    .onClick(this.onClickEvent)
    .onTouch(event => {
      event.stopPropagation();
    })
    .width('100%')
    .height(NotificationUtils.getActionBtnHeight(this.isDropBarVisible))
    .padding({
      top: $r('app.float.ntf_action_view_text_on_touch_effect_up_down_padding'),
      bottom: ResUtils.getNumber($r('app.float.ntf_action_view_text_on_touch_effect_up_down_padding')) +
        (this.isDropBarVisible ? ResUtils.getNumber($r('app.float.ntf_has_drop_bar_add_height')) : 0)
    })
  }

  @Builder
  buildTextButton() {
    Text(this.action?.actionTitle).draggable(false)
      .id(COMPONENT_ID_ACTION_TITLE)
      .fontColor(this.colorModeVM?.ntfThemeTextSecondaryColor)
      .opacity(1)
      .fontWeight(FontWeight.Medium)
      .fontSize(this.fontScaleState.getScaleSize($r('app.float.ntf_title_font_size')))
      .foregroundBrightness(undefined)
      .maxLines(NotificationConfig.ITEM_CONTENT_SINGLE_LINE)
      .textOverflow({ overflow: TextOverflow.Ellipsis })
      .fontWeight(FontWeight.Medium)
      .lineHeight(this.fontScaleState.getScaleSize($r('app.float.ntf_text_line_height')))
      .textAlign(TextAlign.Center)
        // PC&Pad面板监听hover状态
      .onHover(this.isPcOrPad() ? (isHovered? : boolean) => {
        this.isPressedOrHovered = isHovered as boolean;
      } : ()=>{})
      .onTouch((touchEvent) => {this.handleTouchEvent(touchEvent);})
      .margin({
        left: $r('app.float.ntf_item_padding_start_end'),
        right: $r('app.float.ntf_item_padding_start_end'),
      })
  }

  /**
   * 处理触摸事件
   * 1. 触摸按下时 显示背景色;
   * 2. 触摸后移动到组件外时 不显示背景色; 且再移回组件区域也不重新显示背景色
   * 3. 触摸抬起\取消\或其他情况 不显示背景色;
   *
   * @param event 触摸事件
   */
  private handleTouchEvent(event: TouchEvent): void {
    if (!event) {
      return;
    }

    if (TouchType.Down === event.type) {
      this.isPressedOrHovered = true;
    } else if (TouchType.Move == event.type) {
      if (!this.isTouchInArea(event.touches[0], event.target.area)) {
        this.isPressedOrHovered = false;
      }
    } else {
      this.isPressedOrHovered = false;
    }
  }

  private isTouchInArea(touch: TouchObject, area: Area): boolean {
    return touch.x >= 0 && touch.x <= area.width && touch.y >= 0 && touch.y <= area.height;
  }

  /**
   * 获取按钮背景色
   *
   * @return 背景色
   */
  private getBgColor(): ResourceColor | undefined {
    // 按压或鼠标悬停状态
    if (this.isPressedOrHovered) {
      return $r('sys.color.ohos_id_color_hover');
    }
    return Color.Transparent;
  }

  /**
   * 当前是否为PC或Pad类型
   */
  private isPcOrPad(): boolean {
    return DeviceHelper.isPC() || DeviceHelper.isPad();
  }
}