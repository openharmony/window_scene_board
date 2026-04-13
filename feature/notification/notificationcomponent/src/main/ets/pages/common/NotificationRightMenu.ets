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
import { ntfMgr } from '../../model/NotificationManager';
import { CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { DeviceHelper, GlobalContext, ViewType } from '@ohos/frameworkwrapper';
import { ResUtils } from '@ohos/windowscene';
import { ntfSettingsDC as NtfSettingsDC } from '../../controller/NtfSettingsDialogController';
import { NtfSettingsDialogVM } from '../../vm/NtfSettingsDialogVM';
import { NotificationType } from '../../common/NotificationType';
import measure from '@ohos.measure';
import { notificationConfigManager } from '../../manager/NotificationConfigManager';
import { LengthMetrics } from '@kit.ArkUI';
import { ArkUIAdapter } from '@ohos/systemuicommon/src/main/ets/utils/ArkUIAdapter';

const TAG = 'NotificationRightMenu';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

const COMPONENT_ID_MENU_TITLE = TAG + '_Text_menuTitle';
const TEXT_WIDTH_PADDING: number = 25;
const MENU_LEFT_AND_RIGHT_PADDING: number = 8;
const MODULE_NAME = DeviceHelper.is2In1DevicePcType() ? 'phone_settings' : 'pc_settings';

/**
 * 弹框menu标示
 */
export enum RightMenuName {
  // 关闭应用通知
  MenuEnableNtf,
  // 置顶应用通知
  MenuPinTop,
  // 更多设置
  MenuMoreSetting
}

/**
 * 右键点击弹框menu数据
 */
export interface RightMenuItem {
  /**
   * menu标示
   */
  menuName: RightMenuName;

  /**
   * menu按钮名
   */
  menuTitle: Resource;

  /**
   * 条目点击回调
   */
  onItemClick: (entry: NotificationEntry) => void;
}

/**
 * 右键点击弹框menu集
 */
const RIGHT_MENUS_CANCEL_PIN_TOP: RightMenuItem[] = [
// 关闭此应用通知
  {
    menuName: RightMenuName.MenuEnableNtf,
    menuTitle: $r('app.string.ntf_close_pkg_notification'),
    onItemClick: (entry: NotificationEntry) => {
      log.showInfo('click pc menu, disable ntf: ' + entry?.creatorBundleName);
      // 关闭置顶
      notificationConfigManager.setPinTopState(entry?.creatorUid, false).then((isSuccess: boolean) => {
        if (!isSuccess) {
          log.showError('disable ntf,setPinTopState fail')
        }
      });
      // 关闭应用通知功能
      ntfMgr.enablePkgNotification(entry?.creatorBundleName, entry?.creatorUid, false);
    }
  } as RightMenuItem,
  // 取消置顶此应用通知
  {
    menuName: RightMenuName.MenuPinTop,
    menuTitle: $r('app.string.ntf_cancel_pin_top_pkg_notification'),
    onItemClick: (entry: NotificationEntry) => {
      let isDisplayAtTop = entry?.isDisplayAtTop;
      // 取消置顶应用通知功能
      log.showInfo(`click pin top button, current Pin Top:${isDisplayAtTop}, BundleName:${entry?.creatorBundleName}`);
    }
  } as RightMenuItem,
  // 更多设置
  {
    menuName: RightMenuName.MenuMoreSetting,
    menuTitle: $r('app.string.ntf_dialog_more_settings'),
    onItemClick: (entry: NotificationEntry) => {
      log.showInfo('click pc menu, more settings: ' + entry?.creatorBundleName);
      // 对应应用通知管理页
      ntfMgr.startNtfMgrItemAbility(entry?.creatorBundleName, MODULE_NAME, entry?.appIndex);
    }
  } as RightMenuItem
];

/**
 * 右键点击弹框menu集
 */
const RIGHT_MENUS_PIN_TOP: RightMenuItem[] = [
// 关闭此应用通知
  {
    menuName: RightMenuName.MenuEnableNtf,
    menuTitle: $r('app.string.ntf_close_pkg_notification'),
    onItemClick: (entry: NotificationEntry) => {
      log.showInfo('click pc menu, disable ntf: ' + entry?.creatorBundleName);
      // 关闭应用通知功能
      ntfMgr.enablePkgNotification(entry?.creatorBundleName, entry?.creatorUid, false);
    }
  } as RightMenuItem,
  // 置顶此应用通知
  {
    menuName: RightMenuName.MenuPinTop,
    menuTitle: $r('app.string.ntf_pin_top_pkg_notification'),
    onItemClick: (entry: NotificationEntry) => {
      let isDisplayAtTop = entry?.isDisplayAtTop;
      // 置顶应用通知功能
      log.showInfo(`click pin top button, current Pin Top:${isDisplayAtTop}, BundleName:${entry?.creatorBundleName}`);
    }
  } as RightMenuItem,
  // 更多设置
  {
    menuName: RightMenuName.MenuMoreSetting,
    menuTitle: $r('app.string.ntf_dialog_more_settings'),
    onItemClick: (entry: NotificationEntry) => {
      log.showInfo('click pc menu, more settings: ' + entry?.creatorBundleName);
      // 对应应用通知管理页
      ntfMgr.startNtfMgrItemAbility(entry?.creatorBundleName, MODULE_NAME, entry?.appIndex);
    }
  } as RightMenuItem
];

const is2In1DevicePcType = DeviceHelper.is2In1DevicePcType();
/**
 * 鼠标右键点击通知弹框menu
 *
 * @since 2023-01-16
 */
@Component
export struct NotificationRightMenu {
  /**
   * 通知数据
   */
  ntfEntry?: NotificationEntry;

  /**
   * 条目点击监听
   */
  onItemClick?: (item: RightMenuItem) => void;
  changeAppPinTopConfig?: (enable: boolean) => void
  @State isDisplayAtTop: boolean | undefined = false;
  @Provide('menuTextWidth') menuTextWidth: number = 148;
  @State hoverOrPressIndex: number = -1;
  private pinPopMenu: RightMenuItem[] = RIGHT_MENUS_PIN_TOP;
  private cancelPinPopMenu: RightMenuItem[] = RIGHT_MENUS_CANCEL_PIN_TOP;

  aboutToAppear() {
    log.info('aboutToAppear');
    GlobalContext.getContext().eventHub.emit('SubWindowVisible', ViewType.NOTIFICATION_CENTER, true);
    const dialogVm = NtfSettingsDC.getSettingsDialogVM(NotificationType.TYPE_PC) as NtfSettingsDialogVM;
    dialogVm?.setDialogNtfEntry(this.ntfEntry!);
    this.isDisplayAtTop = this.ntfEntry?.isDisplayAtTop;
    // 时钟应用默认开启通知，不允许关闭
    if (this.ntfEntry?.creatorBundleName === 'com.ohos.clock') {
      this.cancelPinPopMenu = RIGHT_MENUS_CANCEL_PIN_TOP.filter(item => item.menuName !== RightMenuName.MenuEnableNtf);
      this.pinPopMenu = RIGHT_MENUS_PIN_TOP.filter(item => item.menuName !== RightMenuName.MenuEnableNtf);
    }
  }

  aboutToDisappear(): void {
    log.info('aboutToDisappear');
  }

  build() {
    Menu() {
      ForEach(this.isDisplayAtTop ? this.cancelPinPopMenu : this.pinPopMenu, (item: RightMenuItem, index) => {
        NotificationRightMenuItem({
          item: item,
          hasDivider: is2In1DevicePcType ? (this.isDisplayAtTop ?
            (index < this.cancelPinPopMenu.length - 1) : (index < this.pinPopMenu.length - 1)) : false,
          hoverOrPressIndex: this.hoverOrPressIndex,
          index: index
        })
          .width(this.menuTextWidth)
          .onClick(() => {
            if (CommonUtils.isInvalid(item.onItemClick)) {
              return;
            }
          // 点击事件处理
          item.onItemClick(this.ntfEntry as NotificationEntry);
          if (item.menuName === RightMenuName.MenuPinTop) {
            this.isDisplayAtTop = this.ntfEntry?.isDisplayAtTop;
            let pinTop = !this.isDisplayAtTop;
            if (this.changeAppPinTopConfig) {
              this.changeAppPinTopConfig(pinTop);
            }
          }
          // 点击事件回调
          if (this.onItemClick && !CommonUtils.isInvalid(this.onItemClick)) {
            this.onItemClick(item);
          }
        })
      })
    }
    .fontColor(Color.Black)
    .font({
      size:  $r('sys.float.ohos_id_text_size_button2'),
      family: 'HarmonyHeiTi'
    })
    .width(this.menuTextWidth + MENU_LEFT_AND_RIGHT_PADDING)
    .padding({
      top: is2In1DevicePcType ? $r('app.float.ntf_qxs_pc_click_menu_padding_top') :
        $r('app.float.ntf_pc_click_menu_padding_top'),
      bottom: $r('app.float.ntf_pc_click_menu_padding_bottom'),
      left: $r('app.float.ntf_pc_click_menu_padding_left'),
      right: $r('app.float.ntf_pc_click_menu_padding_right')
    })
  }
}

@Component
struct NotificationRightMenuItem {
  @State isHover: boolean = false;
  @State isTouch: boolean = false;
  @Prop item: RightMenuItem;
  @Consume menuTextWidth: number;
  @Link hoverOrPressIndex: number;
  private ntfRightMenuFontSize: number = ResUtils.getConvertNumber($r('app.float.ntf_title_font_size'))
  public hasDivider: boolean = false;
  public index: number = -1;

  @Styles normalStyles() {
    .border({
      width: $r('app.float.ntf_pc_menu_item_border'),
      color: $r('app.color.ntf_pc_click_menu_item_normal_border_color')
    })
  }

  @Styles focusedStyles() {
    .border( {
      width: $r('app.float.ntf_pc_menu_item_border'),
      color: $r('app.color.ntf_pc_click_menu_item_focused_border_color')
    })
  }

  aboutToAppear(): void {
    this.setTextWidth();
  }

  private setTextWidth(): void {
    let needTextWidth = Math.round(ArkUIAdapter.px2vp(measure.measureText({
      textContent: this.item?.menuTitle,
      fontSize: this.ntfRightMenuFontSize,
      fontWeight: FontWeight.Medium,
      overflow: TextOverflow.Ellipsis,
      maxLines: 1
    }))) + TEXT_WIDTH_PADDING;
    this.menuTextWidth = needTextWidth > this.menuTextWidth ? needTextWidth : this.menuTextWidth;
  }

  private getBackgroundColor(): ResourceColor {
    if (this.isTouch) {
      return $r('app.color.ntf_pc_click_menu_item_touch_color');
    }
    if (this.isHover) {
      return $r('sys.color.ohos_id_color_hover');
    }
    return $r('app.color.ntf_pc_click_menu_item_normal_color');
  }

  private getBorderRadius(): Resource {
    if (is2In1DevicePcType && this.isHover) {
      return $r('sys.float.corner_radius_level8');
    } else {
      return $r('app.float.ntf_pc_menu_item_border_radius');
    }
  }

  @Builder notificationRightMenuItem() {
    MenuItem() {
      Text(this.item?.menuTitle).draggable(false)
        .id(COMPONENT_ID_MENU_TITLE + '_' + this.item?.menuName)
        .maxLines(NotificationConfig.ITEM_CONTENT_SINGLE_LINE)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .fontWeight(FontWeight.Medium)
        .fontSize($r('app.float.ntf_title_font_size'))
        .fontColor($r('app.color.theme_ntf_color_text_primary'))
        .width('100%')
        .focusable(true)
    }
    .height(is2In1DevicePcType ? $r('app.float.ntf_qxs_pc_menu_item_height') : $r('app.float.ntf_pc_menu_item_height'))
    .width(this.menuTextWidth)
    .backgroundColor(this.getBackgroundColor())
    .stateStyles({
      normal: this.normalStyles,
      focused: this.focusedStyles
    })
    .onTouch((event?: TouchEvent) => {
      if (event?.type === TouchType.Down) {
        this.isTouch = true;
        if (is2In1DevicePcType) {
          this.hoverOrPressIndex = this.index;
        }
      }
      if (event?.type === TouchType.Up) {
        this.isTouch = false;
        if (is2In1DevicePcType) {
          this.hoverOrPressIndex = this.isHover ? this.hoverOrPressIndex : -1;
        }
      }
    })
    .onHover((isHover: boolean) => {
      this.isHover = isHover;
      if (is2In1DevicePcType) {
        if (isHover) {
          this.hoverOrPressIndex = this.index;
        } else {
          this.hoverOrPressIndex = this.isTouch ? this.hoverOrPressIndex : -1;
        }
      }
    })
    .padding({
      start: LengthMetrics.resource($r('app.float.ntf_pc_menu_item_padding_left'))
    })
    .borderRadius(this.getBorderRadius())
  }

  build() {
    if (is2In1DevicePcType) {
      Column(){
        this.notificationRightMenuItem()
        if (this.hasDivider && this.hoverOrPressIndex !== this.index && this.hoverOrPressIndex !== this.index +1) {
          Divider()
            .vertical(false)
            .color($r('sys.color.ohos_id_color_list_separator'))
            .margin({
              start: LengthMetrics.resource($r('app.float.ntf_content_padding_start_end')),
              end: LengthMetrics.resource($r('app.float.ntf_content_padding_start_end'))
            })
        }
      }
    } else {
      this.notificationRightMenuItem()
    }
  }
}