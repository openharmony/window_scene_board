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

import { CommonUtils, LogDomain, LogHelper, Log } from '@ohos/basicutils';
import { ResUtils } from '@ohos/windowscene';
import { ntfMgr } from '../../model/NotificationManager';
import { NotificationEntry } from '../../model/NotificationEntry';
import { NtfItemSwipeController } from '../../controller/NtfItemSwipeController';
import { BrightnessOptionUtils } from '@ohos/systemuicommon/Index';
import { NotificationAccessibilityUtil } from '../../common/NotificationAccessibilityUtil';

const TAG = 'NotificationExtraMenuRow';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

const BIN_HEIGHT = ResUtils.getNumberFromLength($r('app.float.ntf_action_button_del_icon_bin_height'));
const BIN_WIDTH = ResUtils.getNumberFromLength($r('app.float.ntf_action_button_del_icon_bin_width'));
const TRIANGLES_ANGLE_SUM = 180; // sum of the inner angles of the triangle
const DEL_BTN_TRANS_RATIO: number = 6.0; // speed of del btn : speed of card = 1:6
const BIN_COVER_FIRST_GEAR_MAX_ANGLE: number = 12.0; // cover angle between gear1 and gear2 = 0-12°
const DEL_BTN_FIRST_GEAR_SCALE_RATIO: number = 0.05; // del btn scale between gear1 and gear2 = 100-105%
const DEL_BTN_SECOND_GEAR_SCALE_RATIO: number = 0.05; //del btn scale in gear2 = 105-110%

/**
 * menu名称
 */
export enum MenuName {
  // 设置menu
  MenuSettings,
  // 删除menu
  MenuDelete
}

/**
 * 通知左滑menu按钮
 *
 * @since 2023-10-23
 */
@Component
export struct NotificationExtraMenuRow {
  /**
   * menu按钮宽度
   */
  private menuWidth: number = 0;
  private binDelTransXThreshold: number = 100;
  @StorageLink('isLandscape') @Watch('onOrientationChanged') isLandscape: boolean = false;
  @Consume extraNtfList?: Array<NotificationEntry>;
  private coverRotate: number = 0; // cover angle
  @State delScaleButton: number = 1;
  @State delScaleButtonGear2: number = 0; // del btn incremental scale in gear2
  private dropTransX: number = 0;
  @State buttonDelTransX: number = 0;
  @State buttonDelExpandTransX: number = 0;
  @StorageProp('isAccessibilityMode') isAccessibilityMode: boolean = false;
  // bin rotation radius
  private binRadius: number = Math.sqrt(Math.pow(BIN_HEIGHT / 2, 2) + Math.pow(BIN_WIDTH / 2, 2));
  // Angle between bin diagonal and the horizontal line
  private diagonalAngle: number = Math.atan(BIN_HEIGHT / BIN_WIDTH) * TRIANGLES_ANGLE_SUM / Math.PI;
  private isBinExpend: boolean = false;
  /**
   * 删除通知按钮
   */
  private menuDel: MenuItem = {
    menuName: MenuName.MenuDelete,
    menuIcon: $r('app.media.trash_fill'),
    onMenuClick: (): void => {
      Log.showInfo(TAG, 'del data');
      this.groupBriefDel();
    }
  }
  /**
   * 图标透明度动效
   */
  private menuAlphaAnim: AnimateParam | null = null;
  /**
   * 条目横滑控制器
   */
  private swipeController?: NtfItemSwipeController;

  aboutToAppear(): void {
    Log.showInfo(TAG, `aboutToAppear`);
    this.binDelTransXThreshold = this.isLandscape ? 220 : 100;
    // 注册条目横滑监听
    this.swipeController?.registerSwipeCallback(this)
  }

  aboutToDisappear(): void {
    Log.showInfo(TAG, `aboutToDisappear`);
    this.swipeController?.unregisterSwipeCallback(this);
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
    if (CommonUtils.isInvalid(this.menuWidth) ||
      this.menuWidth == 0 ||
      // 从左向右滑动，不显示
      tranX > 0 ||
      // 移除通知时，隐藏
      isRemoveEntry) {
      return;
    }
    let posTranX = Math.abs(tranX);
    if (posTranX >= this.menuWidth) {
      this.dropTransX = posTranX - this.menuWidth;
      this.setCoverState(true);
      this.setButtonDelTransX(true);
      this.setBinTransAnim();
      this.setDelButtonScale(true);
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

  setButtonDelTransX(hasAnim: boolean) {
    if (!hasAnim || this.menuAlphaAnim == undefined) {
      this.buttonDelTransX = -this.dropTransX / DEL_BTN_TRANS_RATIO;
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
      // 最大旋转角度12
      this.coverRotate = Math.min(this.dropTransX / this.binDelTransXThreshold, 1) * BIN_COVER_FIRST_GEAR_MAX_ANGLE;
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
        this.dropTransXBeyond()
      } else {
        this.buttonDelExpandTransX = 0;
        this.delScaleButtonGear2 = 0;
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

  build() {
    Row() {
      Stack({ alignContent: Alignment.Center }) {
        Image(this.menuDel.menuIcon)
          .draggable(false)
          .objectFit(ImageFit.Contain)
          .fillColor($r('app.color.ntf_phone_menu_bg_color'))
          .width($r('app.float.ntf_action_send_icon_size'))
          .height($r('app.float.ntf_action_send_icon_size'))
      }
      .translate({
        x: this.buttonDelTransX + this.buttonDelExpandTransX
      })
      .borderRadius($r('app.float.ntf_menu_row_clear_button_radius'))
      .width($r('app.float.ntf_item_menu_icon_size'))
      .height($r('app.float.ntf_item_menu_icon_size'))
      .backgroundColor($r('app.color.ntf_phone_clear_button_bg_color'))
      .backgroundBrightnessInternal(BrightnessOptionUtils.getInstance().backgroundNineDarkOption)
      .scale({
        x: this.delScaleButton + this.delScaleButtonGear2,
        y: this.delScaleButton + this.delScaleButtonGear2
      })
      .visibility(Visibility.Visible)
      .margin({ left: 12, right: 12 })
      // 按钮显示时设置点击事件
      .onClick(() => {
        Log.showInfo(TAG, 'on menu click: ' + this.menuDel.menuName);
        this.menuDel.onMenuClick();
        NotificationAccessibilityUtil.sendNtfRemoveAccessibility(true);
      })
      .accessibilityText(this.getAccessibilitySettingText(this.menuDel.menuName))
      .accessibilityRole(AccessibilityRoleType.BUTTON)
    }
    .height($r('app.float.ntf_action_button_height'))
    .padding({
      left: $r('app.float.ntf_item_padding_start_end')
    })
    .onAreaChange((oldArea, newArea) => {
      // 横滑左滑时，根据menu宽度控制可滑动距离
      this.menuWidth = newArea.width as number;
    })
  }

  private getAccessibilitySettingText(menuName: MenuName): string {
    if (!this.isAccessibilityMode) {
      return '';
    }
    if (menuName === MenuName.MenuDelete) {
      return ResUtils.getInnerString($r('app.string.accessibility_notification_delete_bar'));
    }
    return '';
  }

  /**
   * 横竖屏切换回调
   */
  private onOrientationChanged() {
    this.binDelTransXThreshold = this.isLandscape ? 220 : 100;
  }

  private toRadians(degree: number): number {
    return degree * Math.PI / TRIANGLES_ANGLE_SUM
  }

  private groupBriefDel(): void {
    let deleteList: NotificationEntry[] = [];
    this.extraNtfList?.forEach((entry, index) => {
      if (this.canDel(entry) && entry.isGroup) {
        entry.childrenEntry?.forEach((childEntry) => {
          deleteList.push(childEntry);
        });
      }
    });
    ntfMgr.batchRemoveNtf(deleteList);
  }

  private canDel(entry: NotificationEntry): boolean {
    if (entry && entry.canDelete() && entry.isExtraContentType()) {
      return true;
    }
    return false;
  }

  private dropTransXBeyond():void {
    let sita: number = TRIANGLES_ANGLE_SUM - this.diagonalAngle - this.coverRotate;
    let sitaRadians = this.toRadians(sita);

    let buttonWidth = ResUtils.getNumberFromLength($r('app.float.ntf_item_right_icon_size')) * this.delScaleButton / 2;
    this.buttonDelExpandTransX = -(this.binDelTransXThreshold + this.menuWidth - buttonWidth) / 2 -
    this.buttonDelTransX;
    this.delScaleButtonGear2 = DEL_BTN_SECOND_GEAR_SCALE_RATIO;
  }
}

/**
 * menu条目
 */
export interface MenuItem {
  /**
   * menu名称
   */
  menuName: MenuName;

  /**
   * menu图标
   */
  menuIcon: Resource;

  /**
   * menu按钮点击回调
   *
   * @param param 参数
   */
  onMenuClick: () => void;
}