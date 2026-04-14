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
import { NtfItemSwipeController } from '../../controller/NtfItemSwipeController';
import { ntfSettingsDC as NtfSettingsDC } from '../../controller/NtfSettingsDialogController';
import { LogDomain, LogHelper, CommonUtils, ArrayUtils, RectInfo } from '@ohos/basicutils';
import { ItemUtils, RTLUtil } from '@ohos/componenthelper';
import { HiDfxEventUtil, DeviceHelper } from '@ohos/frameworkwrapper';
import { ResUtils, SCBSystemSceneSession, SCBSceneSessionManager } from '@ohos/windowscene';
import { NotificationType } from '../../common/NotificationType';
import { NotificationSysEventReporter, DefaultPanelZIndex } from '@ohos/systemuicommon';
import { DropDownPanelManager } from '@ohos/systemuicommon/Index';
import { BlurButtonVM, blurButtonVM } from '../../vm/BlurButtonVM';
import { ScreenLockBlurButtonVM, screenLockBlurButtonVM } from '../../vm/ScreenLockBlurButtonVM';
import { NtfColorModeVM } from '../../vm/NtfColorModeVM';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { NotificationUtils } from '../../common/NotificationUtils';
import { ntfViewConfigManager } from '../../vm/config/NtfViewConfigManager';
import { LengthMetrics } from '@ohos.arkui.node';
import { DeleteNotificationMaintenance } from '@ohos/systemuicommon/src/main/ets/maintenance/DeleteNotificationMaintenance';
import { DeleteNotificationType } from '@ohos/systemuicommon/src/main/ets/maintenance/StatisticsConstants';
import { LogWithHa } from '@ohos/systemuicommon/src/main/ets/maintenance/CommonExceptionMaintenance';
import { NotificationExceptionCode } from '../../maintenance/NotificationExceptionCode';

const TAG = 'NotificationMenuRow';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

const COMPONENT_ID_MENU_DELETE_ICON = TAG + '_Image_menu_deleteIcon';

const COMPONENT_ID_MENU_SETTING_ICON = TAG + '_Image_menu_settingIcon';

const PARENT_COMPONENT = 'NotificationListItem'

const KG_SUFFIX = '_KG';

/**
 * 最大alpha值
 */
const MAX_ALPHA = 1.0;

/**
 * menu名称
 */
enum MenuName {
  // 设置menu
  MenuSettings,
  // 删除menu
  MenuDelete
}

/**
 * 设置按钮
 */
const MENU_SETTING: MenuItem = {
  menuName: MenuName.MenuSettings,
  menuIcon: $r('app.media.ic_public_more'),
  menuIcon2: $r('app.media.ic_public_more'),
  onMenuClick: (param: ClickParam): void => {
    NtfSettingsDC.showDialog(param.ntfType, param.ntfEntry);
    HiDfxEventUtil.reportClickDeleteInNtfMenu(param.ntfEntry?.creatorBundleName, param.ntfEntry?.id);
    NotificationSysEventReporter.notificationPanelSlipSetting({
      NOTIFICATION_SLOT_TYPE: param.ntfEntry?.slotType,
      CREATOR_BUNDLE_NAME: param.ntfEntry?.creatorBundleName,
      TIME_STAMP: param.ntfEntry.slotLevel !== 3 ? `${DropDownPanelManager.getLastDropdownTime()}` : undefined,
      NOTIFICATION_ID: param.ntfEntry?.id,
      BUNDLE_TYPE: param.ntfEntry?.bundleType,
      TRACE_ID: param.ntfEntry?.traceId,
    });
  }
}

/**
 * 删除通知按钮
 */
const MENU_DEL: MenuItem = {
  menuName: MenuName.MenuDelete,
  menuIcon: $r('app.media.trash_cover'),
  menuIcon2: $r('app.media.trash_bin'),
  onMenuClick: (param: ClickParam): void => {
    DeleteNotificationMaintenance.addNtfMap(param.ntfEntry.isGroup ? param.ntfEntry.childrenEntry : [param.ntfEntry],
      DeleteNotificationType.LEFT_SLIDE_CLICK_DELETE, param.isInGroup);
    param.swipeController?.swipe2Delete();
    HiDfxEventUtil.reportClickDeleteInNtfMenu(param.ntfEntry?.creatorBundleName, param.ntfEntry?.id);
    NotificationSysEventReporter.notificationPanelSlipLeftDelete({
      DISPLAY_SCENE: NotificationType.isKeyguard(param.ntfType) ? 2 : 4,
      CREATOR_BUNDLE_NAME: param.ntfEntry?.creatorBundleName,
      NOTIFICATION_ID: param.ntfEntry?.id,
      NOTIFICATION_SLOT_TYPE: param.ntfEntry?.isInAggregate ? null : param.ntfEntry?.slotType,
      TIME_STAMP: NotificationUtils.getNtfTimeStampByType(param.ntfType),
      IS_GROUP: param.ntfEntry?.isGroup ? 1 : param.isInGroup ? 2 : 0,
      IS_AGGREGATE: param.ntfEntry?.isInAggregate ? 1 : 0,
      NOTIFICATION_CONTROL_FLAGS: param.ntfEntry?.controlConfig?.flags,
      TRACE_ID: param.ntfEntry?.traceId
    });
  }
}

const COVER_ROTATE_RADIUS: number = ResUtils.getNumberFromLength($r('app.float.ntf_action_send_icon_size')) / 2;
const BIN_HEIGHT = ResUtils.getNumberFromLength($r('app.float.ntf_action_button_del_icon_bin_height'));
const BIN_WIDTH = ResUtils.getNumberFromLength($r('app.float.ntf_action_button_del_icon_bin_width'));
const ITEM_PADDING = ResUtils.getNumberFromLength($r('app.float.ntf_item_padding_start_end'));
const ITEM_ICON_SIZE = ResUtils.getNumberFromLength($r('app.float.ntf_item_menu_icon_size'));
const TRIANGLES_ANGLE_SUM = 180; // sum of the inner angles of the triangle
const DEL_BTN_TRANS_RATIO: number = 2.0; // speed of del btn : speed of card = 1:6
const SETTING_BTN_TRANS_RATIO: number = 12.0 / 7.0; // speed of setting btn : speed of card = 3.5:6
const BIN_COVER_FIRST_GEAR_MAX_ANGLE: number = 12.0; // cover angle between gear1 and gear2 = 0-12°
const BIN_COVER_SECOND_GEAR_ANGLE: number = 5.0; // cover angle between in gear2 = 12-17°
const DEL_BTN_FIRST_GEAR_SCALE_RATIO: number = 0.05; // del btn scale between gear1 and gear2 = 100-105%
const DEL_BTN_SECOND_GEAR_SCALE_RATIO: number = 0.05; //del btn scale in gear2 = 105-110%
const BIN_BODY_SECOND_GEAR_MAX_ANGLE: number = -10.0; // bin angle in gear2 = 10°


/**
 * 通知左滑menu按钮
 *
 * @since 2023-01-10
 */
@Component
export struct NotificationMenuRow {
  /**
   * 通知数据
   */
  private ntfEntry?: NotificationEntry;

  /**
   * 条目横滑控制器
   */
  private swipeController?: NtfItemSwipeController;

  /**
   * menu按钮宽度
   */
  private menuWidth: number = 0;
  private binDelTransXThreshold: number = 100;
  /**
   * 面板类型
   */
  @Consume notificationType: number;
  @StorageLink('isLandscape') @Watch('onOrientationChanged') isLandscape: boolean = false;
  /**
   * menu按钮集
   */
  @State menuItems: Array<MenuItem> = [];

  /**
   * 图标透明度，默认透明
   */
  @State settingIconAlpha: number = 0; // alpha of setting btn
  @State delIconAlpha: number = 0; // alpha of del btn
  @State coverRotate: number = 0; // cover angle
  @State coverRotateGear2: number = 0; // cover incremental angle in gear2
  @State binRotate: number = 0; // bin angle
  @State coverTransX: number = 0;
  @State coverTransY: number = 0;
  @State binTransX: number = 0;
  @State binTransY: number = 0;
  @State delScaleButton: number = 1;
  @State delScaleButtonGear2: number = 0; // del btn incremental scale in gear2
  @State buttonDelTransX: number = 0;
  @State buttonDelExpandTransX: number = 0;
  @State buttonSettingsTransX: number = 0;

  private dropTransX: number = 0;

  // bin rotation radius
  private binRadius: number = Math.sqrt(Math.pow(BIN_HEIGHT / 2, 2) + Math.pow(BIN_WIDTH / 2, 2));

  // Angle between bin diagonal and the horizontal line
  private diagonalAngle: number = Math.atan(BIN_HEIGHT / BIN_WIDTH) * TRIANGLES_ANGLE_SUM / Math.PI;
  private isBinExpend: boolean = false;
  /**
   * 横滑阈值内，垃圾桶盖移动距离系数
   */
  private coverTransXRateInThreshold: number = 8;
  /**
   * 横滑阈值外，垃圾桶盖移动距离系数
   */
  private coverTransXRateOutOfThreshold: number = 2;
  /**
   * 删除按钮消失时，往左横滑距离
   */
  private delButtonTranX: number = 50;
  /**
   * 图标透明度动效
   */
  private menuAlphaAnim: AnimateParam | null = null;

  /**
   * 无障碍模式下按钮播报文本
   */
  @State menuAccessibilityDescription: string = ResUtils.getInnerString($r('app.string.cc_accessibility_str_click'));

  /**
   * 通知面板背景模糊VM
   */
  @State @Watch('onDropPanelBlurButtonChanged') blurButtonVM: BlurButtonVM = blurButtonVM;
  /**
   * 锁屏面板背景模糊VM
   */
  @State @Watch('onScreenLockBlurButtonChanged') screenLockBlurButtonVM: ScreenLockBlurButtonVM = screenLockBlurButtonVM;

  /**
   * 灰阶提亮VM
   */
  @State colorModeVM: NtfColorModeVM | undefined = undefined;

  /**
   * 是否为分组中的条目
   */
  private isInGroup: boolean = false;

  /**
   * 是否触发显示设置对话框
   */
  private isShowSettingDialog: boolean = false;

  /**
   * 通知设置弹窗菜单显隐
   */
  private isShowNtfSettingsDialogBindMenu: boolean = false;

  aboutToAppear(): void {
    log.showInfo(`aboutToAppear`);
    // 初始化
    this.refreshNtfData();
    // 注册数据更新监听
    this.ntfEntry?.registerDataUpdateListener(this);
    // 注册条目横滑监听
    this.swipeController?.registerSwipeCallback(this);
    this.swipeController?.setItemMenuWidth(this.getMenusWidth());
    this.binDelTransXThreshold = this.isLandscape ? 220 : 100;
    this.swipeController?.setMenuDelThreshold(this.binDelTransXThreshold);
    // 注册设置弹窗监听
    NtfSettingsDC.registerSettingDialogCallback(this);
  }

  aboutToDisappear(): void {
    log.showInfo(`aboutToDisappear`);
    if (this.swipeController?.isSwipeExpand()) {
      log.showInfo(`start collapse when disappear`); //确保通知能够回到初始态
      this.swipeController?.swipe2Collapse()
    }
    this.ntfEntry?.unregisterDataUpdateListener(this);
    this.swipeController?.unregisterSwipeCallback(this);
    NtfSettingsDC.unregisterSettingDialogCallback(this);
    this.setStatusBarZIndex('reset');
  }

  cancelBlur(): void {
    if (NotificationType.isKeyguard(this.notificationType)) {
      this.screenLockBlurButtonVM.unblur();
    } else {
      this.blurButtonVM.unblur();
    }
  }

  onDropPanelBlurButtonChanged(): void {
    if (this.settingIconAlpha === 0 &&
      !this.blurButtonVM.getIsButtonClick() && !this.blurButtonVM.getShouldBlur() &&
      this.isShowSettingDialog) {
      this.isShowSettingDialog = false;
      NtfSettingsDC.hideDialog(this.notificationType);
      this.settingIconAlpha = MAX_ALPHA;
      this.setStatusBarZIndex('reset');
    }
  }

  onScreenLockBlurButtonChanged(): void {
    if (this.settingIconAlpha === 0 &&
      !this.screenLockBlurButtonVM.getIsButtonClick() && !this.screenLockBlurButtonVM.getShouldBlur() &&
      this.isShowSettingDialog) {
      this.isShowSettingDialog = false;
      NtfSettingsDC.hideDialog(this.notificationType);
      this.settingIconAlpha = MAX_ALPHA;
      this.setStatusBarZIndex('reset');
    }
  }

  /*
   * 打开通知设置弹窗，设置状态栏层级，状态栏层级比页面层级高，状态栏层级需降级
   * 关闭通知设置弹窗，重置状态栏层级
   */
  private setStatusBarZIndex(action: 'update' | 'reset'): void {
    try {
      if (DeviceHelper.isPC()) {
        return;
      }
      const sysSessionStatusBar: SCBSystemSceneSession = SCBSceneSessionManager.getInstance()
        .getSystemSceneSessionWithSystemType(sceneSessionManager.SessionType.TYPE_STATUS_BAR);
      if (!sysSessionStatusBar) {
        log.showInfo(`failed to get sysSessionStatusBar`);
        return;
      }
      if (action === 'update') {
        sysSessionStatusBar.zIndex = DefaultPanelZIndex.PANEL_STATUS_BAR_LOWER;
      }
      if (action === 'reset') {
        sysSessionStatusBar.zIndex = DefaultPanelZIndex.PANEL_STATUS_BAR;
      }
      log.showInfo(`setStatusBarZIndex success, zIndex: ${sysSessionStatusBar.zIndex}`);
    } catch (err) {
      LogWithHa.error(log, `setStatusBarZIndex failed, err: ${err}`, NotificationExceptionCode.SET_STATUS_BAR_INDEX_FAIL, err);
    }
  }

  /**
   * 横竖屏切换回调
   */
  private onOrientationChanged() {
    this.binDelTransXThreshold = this.isLandscape ? 220 : 100;
    this.swipeController?.setMenuDelThreshold(this.binDelTransXThreshold);
  }
  /**
   * 更新通知条目横向平移距离
   * SwipeCallback
   *
   * @param tranX 平移距离
   * @param isRemoveEntry 是否移除通知
   */
  onUpdateItemTranX(tranX: number, isRemoveEntry: boolean): void {
    // 通过触摸位移计算alpha值
    let isStart2End = RTLUtil.isRTL() ? tranX < 0 : tranX > 0;
    if (CommonUtils.isInvalid(this.menuWidth) ||
      this.menuWidth == 0 ||
      // 从左向右滑动，不显示
      isStart2End) {
      this.setMenuIconAlpha(0, false, isRemoveEntry);
      return;
    }
    let posTranX = Math.abs(tranX);
    if (posTranX >= this.menuWidth) {
      this.dropTransX = posTranX - this.menuWidth;
      if (this.swipeController?.isItemCanClear) {
        this.setCoverState(true);
        this.setBinTransAnim();
      }
      this.setButtonDelTransX(true);
      this.setDelButtonScale(true);
      if (this.dropTransX < this.binDelTransXThreshold) {
        this.setMenuIconAlpha(MAX_ALPHA, true);
      } else if (isRemoveEntry) {
        this.setMenuIconAlpha(0, false, isRemoveEntry);
      } else if (!isRemoveEntry && this.delIconAlpha === 0) {
        this.delIconAlpha = MAX_ALPHA;
        if (!this.swipeController?.isItemCanClear) {
          this.settingIconAlpha = MAX_ALPHA;
        }
      }
    } else {
      this.setMenuIconAlpha(posTranX / this.menuWidth, true);
    }
  }

  setDelButtonScale(hasAnim: boolean) {
    if (!hasAnim || this.menuAlphaAnim == undefined) {
      let ratio = this.dropTransX / this.binDelTransXThreshold;
      ratio = Math.max(ratio, 0);
      ratio = Math.min(ratio, 1.0)
      this.delScaleButton = 1 + (ratio * DEL_BTN_FIRST_GEAR_SCALE_RATIO);
      return;
    }
    animateTo(this.menuAlphaAnim, () => {
      this.setDelButtonScale(false);
    });
  }

  setMenuIconAlpha(alpha: number, hasAnim: boolean, isRemoveEntry?: boolean): void {
    if (isRemoveEntry == true && Math.ceil(this.dropTransX) > this.binDelTransXThreshold) {
      // 删除按钮消失时增加过渡效果
      animateTo(this.menuAlphaAnim as AnimateParam, () => {
        this.settingIconAlpha = alpha;
        this.delIconAlpha = alpha;
        this.buttonDelTransX = RTLUtil.isRTL() ? this.buttonDelTransX + this.delButtonTranX :
        this.buttonDelTransX - this.delButtonTranX;
      })
      return;
    }
    if (!hasAnim || this.menuAlphaAnim == undefined) {
      this.delIconAlpha = alpha;
      this.settingIconAlpha = alpha;
      return;
    }
    animateTo(this.menuAlphaAnim, () => {
      this.setMenuIconAlpha(alpha, false);
    })
  }

  setButtonDelTransX(hasAnim: boolean) {
    if (!hasAnim || this.menuAlphaAnim == undefined) {
      let mark = RTLUtil.isRTL() ? 1 : -1
      this.buttonSettingsTransX = mark * this.dropTransX / SETTING_BTN_TRANS_RATIO;
      this.buttonDelTransX = mark * this.dropTransX / DEL_BTN_TRANS_RATIO;
      return;
    }
    animateTo(this.menuAlphaAnim, () => {
      this.setButtonDelTransX(false);
    })
  }

  /**
   *  垃圾桶盖，看做线段，旋转为中心点，需旋转时计算平移，使之形似以右端点为圆心旋转
   */
  setCoverState(hasAnim: boolean) {
    if (!hasAnim || this.menuAlphaAnim == undefined) {
      this.coverRotate = Math.min(this.dropTransX / this.binDelTransXThreshold, 1) * BIN_COVER_FIRST_GEAR_MAX_ANGLE;
      let coverRadian: number = this.toRadians(this.coverRotate); // 旋转弧度
      this.coverTransY = -Math.sin(coverRadian) * COVER_ROTATE_RADIUS;
      this.coverTransX = COVER_ROTATE_RADIUS * (Math.cos(coverRadian) - 1);
      if (this.dropTransX > this.binDelTransXThreshold) {
        this.coverTransX *= this.coverTransXRateOutOfThreshold
      } else {
        this.coverTransX *= this.coverTransXRateInThreshold
      }
      return;
    }
    animateTo(this.menuAlphaAnim, () => {
      this.setCoverState(false);
    })
  }

  /**
   *  垃圾桶身，长方形，旋转为中心点，需旋转时计算平移，使之形似以右上角为圆心旋转
   */
  setBinTransAnim() {
    let dropTransXBeyondThreshold: boolean = this.dropTransX > this.binDelTransXThreshold;
    if ((dropTransXBeyondThreshold && this.isBinExpend) || (!dropTransXBeyondThreshold && !this.isBinExpend)) {
      return;
    }
    this.isBinExpend = dropTransXBeyondThreshold;
    animateTo({
      duration: 200, // 动画时长
      curve: Curve.Friction, // 动画曲线
      delay: 0, // 动画延迟
      iterations: 1, // 播放次数
      playMode: PlayMode.Normal, // 动画模式
    }, () => {
      if (dropTransXBeyondThreshold) {
        let mark = RTLUtil.isRTL() ? 1 : -1
        this.binRotate = BIN_BODY_SECOND_GEAR_MAX_ANGLE;
        let sita: number = TRIANGLES_ANGLE_SUM - this.diagonalAngle - this.coverRotate;
        let sitaRadians = this.toRadians(sita);
        let hypotenuse: number = BIN_HEIGHT / (2 * Math.sin(sitaRadians)); // right-angled triangle hypotenuse length
        this.binTransY = Math.sin(sitaRadians) * (this.binRadius - hypotenuse); // offset of bin center point

        let x1: number = BIN_HEIGHT / (2 * Math.tan(sitaRadians)); // 相似三角形，对角相等
        let x2: number = this.binTransY / Math.tan(sitaRadians);
        this.binTransX = x1 + x2 + BIN_WIDTH / 2; // 垃圾桶中心点横向位移距离
        let buttonWidth = ResUtils.getNumberFromLength($r('app.float.ntf_item_right_icon_size')) * this.delScaleButton / 2;
        let rightMarginWidth = ResUtils.getNumberFromLength($r('app.float.ntf_extra_content_width'));
        this.buttonDelExpandTransX = mark * buttonWidth - rightMarginWidth;
        this.delScaleButtonGear2 = DEL_BTN_SECOND_GEAR_SCALE_RATIO;
        this.coverRotateGear2 = BIN_COVER_SECOND_GEAR_ANGLE;
      } else {
        this.binRotate = 0;
        this.binTransY = 0;
        this.binTransX = 0;
        this.buttonDelExpandTransX = 0;
        this.delScaleButtonGear2 = 0;
        this.coverRotateGear2 = 0;
      }
    })

    this.animateSettingIconAlpha(dropTransXBeyondThreshold);
  }

  private animateSettingIconAlpha(dropTransXBeyondThreshold: boolean): void {
    animateTo({
      duration: 50, // 动画时长
      curve: Curve.Friction, // 动画曲线
      delay: (dropTransXBeyondThreshold ? 0 : 50), // 动画延迟，设置显隐时区分淡入淡出时延，避免与垃圾桶重叠
      iterations: 1, // 播放次数
      playMode: PlayMode.Normal, // 动画模式
    }, () => {
      if (dropTransXBeyondThreshold && this.ntfEntry?.canDelete()) {
        this.settingIconAlpha = 0;
      } else {
        this.settingIconAlpha = MAX_ALPHA;
      }
    })
  }

  /**
   * 更新通知条目横向平移动画
   * SwipeCallback
   *
   * @param itemAnim 动画
   */
  onUpdateItemAnim(itemAnim: AnimateParam): void {
    this.menuAlphaAnim = itemAnim;
  }

  /**
   * 通知数据变化回调
   * NtfDataUpdateListener
   *
   * @param newEntry 新通知对象
   */
  onNtfDataUpdate(newEntry: NotificationEntry): void {
    this.ntfEntry = newEntry;
    this.refreshNtfData();
  }

  private getAccessibilitySettingText(menuName: MenuName): string {
    if (menuName == MenuName.MenuDelete) {
      return ResUtils.getInnerString($r('app.string.accessibility_notification_delete_bar'));
    }
    if (menuName == MenuName.MenuSettings) {
      return ResUtils.getInnerString($r('app.string.accessibility_notification_setting_bar'));
    }
    return '';
  }

  build() {
    RelativeContainer() {
      ForEach(this.menuItems, (menuItem: MenuItem, index?: number) => {
        Column() {
          this.buildMenuItem(menuItem, index);
        }
        .justifyContent(FlexAlign.Center)
        .borderRadius($r('app.float.ntf_menu_row_clear_button_radius'))
        .translate({
          x: menuItem.menuName == MenuName.MenuDelete ? this.buttonDelTransX + this.buttonDelExpandTransX
            : this.buttonSettingsTransX
        })
        .id(menuItem.menuName == MenuName.MenuDelete ? this.getMenuDeleteId() : this.getImageId())
        .width($r('app.float.ntf_item_menu_icon_size'))
        .height($r('app.float.ntf_item_menu_icon_size'))
        .backgroundColor(this.isInGroup ? this.colorModeVM?.themeClearButtonBgCardColor :
          this.colorModeVM?.themeClearButtonBgColor)
        .backgroundBrightnessInternal(this.colorModeVM?.themeMenuButtonBgOptions)
        .scale({
          x: menuItem.menuName == MenuName.MenuDelete ? this.delScaleButton + this.delScaleButtonGear2 : 1,
          y: menuItem.menuName == MenuName.MenuDelete ? this.delScaleButton + this.delScaleButtonGear2 : 1
        })
        .margin(this.getButtonColumnMargin(menuItem))
        // 透明度
        .opacity(menuItem.menuName == MenuName.MenuDelete ? this.delIconAlpha : this.settingIconAlpha)
        // 按钮显示时设置点击事件
        .onClick(() => this.onClickMenuItem(menuItem))
        .accessibilityRole(AccessibilityRoleType.BUTTON)
        // 不播报按钮名称，也不播报新手提醒（单指双击等），Description使用' '而不是''是为了适配无障碍的属性读取拼接方式变更
        .accessibilityText(this.getAccessibilitySettingText(menuItem.menuName))
        .accessibilityDescription(this.menuAccessibilityDescription)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          end: {
            anchor: this.checkIsOnlySettingMenuOrIsDeleteMenu(menuItem) ? '__container__' : this.getMenuDeleteId(),
            align: this.checkIsOnlySettingMenuOrIsDeleteMenu(menuItem) ? HorizontalAlign.End : HorizontalAlign.Start
          },
        })
      });
    }
    .height($r('app.float.ntf_action_button_height'))
    .clip(true)
  }

  @Builder
  buildMenuItem(menuItem: MenuItem, index?: number) {
    if (menuItem.menuName == MenuName.MenuDelete) {
      Stack({ alignContent: Alignment.TopStart }) {
        Image(menuItem.menuIcon).draggable(false)
          .objectFit(ImageFit.Contain)
          .fillColor($r('app.color.ntf_phone_menu_bg_color'))
          .width($r('app.float.ntf_action_send_icon_size'))
          .height($r('app.float.ntf_action_send_icon_size'))
          .rotate({ z: 1, angle: NotificationUtils.getRTLValue(this.coverRotate + this.coverRotateGear2) })
          .translate({ x: NotificationUtils.getRTLValue(this.coverTransX), y: this.coverTransY })
          .id(`${TAG}_Image_delIcon1_${index}`)
        Image(menuItem.menuIcon2).draggable(false)
          .objectFit(ImageFit.Contain)
          .fillColor($r('app.color.ntf_phone_menu_bg_color'))
          .width($r('app.float.ntf_action_send_icon_size'))
          .height($r('app.float.ntf_action_send_icon_size'))
          .rotate({ z: 1, angle: NotificationUtils.getRTLValue(this.binRotate) })
          .translate({ x: NotificationUtils.getRTLValue(this.binTransX), y: this.binTransY })
          .id(`${TAG}_Image_delIcon2_${index}`)
      }
      .id(COMPONENT_ID_MENU_DELETE_ICON)
    } else {
      Image(this.logWrapperIconResource(menuItem.menuIcon)).draggable(false)
        .id(COMPONENT_ID_MENU_SETTING_ICON)
        .objectFit(ImageFit.Contain)
        .fillColor($r('app.color.ntf_phone_menu_bg_color'))
        .width($r('app.float.ntf_action_send_icon_size'))
        .height($r('app.float.ntf_action_send_icon_size'))
    }
  }

  private logWrapperIconResource(icon: Resource): Resource {
    if (this.settingIconAlpha === 1) {
      log.showInfo('build icon for [%{public}d] button alpha [%{public}d]', icon?.id, this.settingIconAlpha);
    }
    return icon;
  }

  private getButtonColumnMargin(menuItem: MenuItem): Margin | Length | LocalizedMargin {
    return {
      // 如果只有一个按钮或者当前按钮为删除按钮，则右边距为12vp；否则右边距为（12 * 2）vp
      end: this.checkIsOnlySettingMenuOrIsDeleteMenu(menuItem) ? LengthMetrics.vp(ITEM_PADDING) :
      LengthMetrics.vp(ITEM_PADDING * 2)
    }
  }

  private getImageId(): string {
    if (NotificationType.isKeyguard(this.notificationType)) {
      return COMPONENT_ID_MENU_SETTING_ICON + this.ntfEntry?.getGroupTypeKey() + '_' + this.ntfEntry?.hashCode + KG_SUFFIX;
    }
    return COMPONENT_ID_MENU_SETTING_ICON + this.ntfEntry?.getGroupTypeKey() + '_' + this.ntfEntry?.hashCode;
  }

  private onClickMenuItem(menuItem: MenuItem) : void {
    log.showInfo('on menu click: [%{public}d] alpha [%{public}d]', menuItem.menuName, this.delIconAlpha);
    if (this.delIconAlpha === MAX_ALPHA) {
      menuItem.onMenuClick({
        ntfEntry: this.ntfEntry as NotificationEntry,
        swipeController: this.swipeController,
        ntfType: this.notificationType,
        isInGroup: this.isInGroup
      });
    }
    if (menuItem.menuName === MenuName.MenuSettings) {
      this.settingIconAlpha = 0;
      this.isShowSettingDialog = true;
      this.setStatusBarZIndex('update');
      let rect: RectInfo = ItemUtils.getRectById(this.getImageId());
      // 父组件Y轴偏移量
      let translateY = ItemUtils.getRectangleById(this.getParentComponentId())?.translate?.y ?? 0;
      // 增加偏移量
      rect.top = rect.top + translateY;
      if (NotificationType.isKeyguard(this.notificationType)) {
        this.screenLockBlurButtonVM.blur({ x: rect.left, y: rect.top });
      } else {
        this.blurButtonVM.blur({ x: rect.left, y: rect.top });
      }
    }
  }

  private toRadians(degree: number): number {
    return degree * Math.PI / TRIANGLES_ANGLE_SUM
  }

  private isPc(): boolean {
    return NotificationType.isPc(this.notificationType);
  }

  /**
   * 刷新通知数据
   */
  private refreshNtfData(): void {
    let canDel = this.ntfEntry?.canDelete() ?? false;
    ArrayUtils.clearArr(this.menuItems);
    const isNeedSetting = this.ntfEntry?.canShowSetting(this.notificationType, this.isInGroup,
      ntfViewConfigManager.getListContentConfig().isOuterHome);
    if (isNeedSetting) {
      log.showInfo(`Setting button is shown`);
      this.menuItems.push(MENU_SETTING);
    }
    // 允许删除则显示删除按钮
    if (canDel) {
      log.showInfo(`Delete button is shown`);
      this.menuItems.push(MENU_DEL);
    }
    this.swipeController?.setItemMenuWidth(this.getMenusWidth());
  }

  /**
   * 获取通知面板类型
   * 复写NtfListVm.NtfListCallback
   *
   * @return 通知类型
   */
  getNtfType(): number {
    return this.notificationType;
  }

  private getMenuDeleteId(): string {
    return COMPONENT_ID_MENU_DELETE_ICON + this.ntfEntry?.hashCode;
  }

  private checkIsOnlySettingMenuOrIsDeleteMenu(menuItem: MenuItem): boolean {
    return this.menuItems?.length === 1 || menuItem.menuName === MenuName.MenuDelete;
  }

  private getMenusWidth(): number {
    if (ArrayUtils.isEmpty(this.menuItems)) {
      return 0;
    }
    // 单个按钮的宽度包含2个外边距 + 按钮本身宽度
    let singleMenuWidth = ITEM_PADDING * 2 + ITEM_ICON_SIZE;
    this.menuWidth = this.menuItems.length * singleMenuWidth;
    return this.menuWidth;
  }

  /**
   * 获取父组件Id 与NotificationListItem的getStackId一致
   *
   * @returns 父组件Id
   */
  private getParentComponentId(): string {
    return PARENT_COMPONENT + '_' + this.notificationType + '_' + this.getNtfEntry()?.getGroupTypeKey() + '_' +
      this.getNtfEntry()?.hashCode;
  }

  private getNtfEntry(): NotificationEntry | undefined {
    return this.ntfEntry?.isGroup ? this.ntfEntry?.getFirstChildEntry() : this.ntfEntry;
  }
}

/**
 * menu点击参数
 */
interface ClickParam {
  /**
   * 通知数据
   */
  ntfEntry: NotificationEntry;

  /**
   * 横滑助手
   */
  swipeController?: NtfItemSwipeController;

  /**
   * 通知面板类型
   */
  ntfType: number;

  /**
   * 是否在组通知内
   */
  isInGroup?: boolean;
}

/**
 * menu条目
 */
interface MenuItem {
  /**
   * menu名称
   */
  menuName: MenuName;

  /**
   * menu图标
   */
  menuIcon: Resource;
  menuIcon2: Resource;

  /**
   * menu按钮点击回调
   *
   * @param param 参数
   */
  onMenuClick: (param: ClickParam) => void;
}