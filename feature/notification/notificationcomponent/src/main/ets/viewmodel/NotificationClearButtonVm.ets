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

import { NotificationBase, NotificationDataManager } from '@ohos/systemuicommon/newTsIndex';
import {
  DeviceInfoVm,
  DropdownVm,
  INotificationClearButtonVm,
  INotificationListVm,
  INotificationMoreHeaderVm,
  INotificationVmInjector,
  NotificationBaseVm
} from '@ohos/systemuicommon/newIndex';
import { notificationManager } from '@kit.NotificationKit';
import { NotificationApiUtil } from '../utils/NotificationApiUtil';
import { NotificationClearAllAnimation } from '../animation/NotificationClearAllAnimation';
import { NotificationSysEventReporter } from '@ohos/systemuicommon';
import { DropDownPanelManager } from '@ohos/systemuicommon/Index';
import { LengthMetrics } from '@kit.ArkUI';
import { CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { HiDfxEventUtil } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { ItemUtils } from '@ohos/componenthelper';
import { NotificationStyle } from '../constants/NotificationStyle';
import {
  NotificationMoreHeaderModel
} from '@ohos/systemuicommon/src/main/ets/notification/model/NotificationMoreHeaderModel';
import { StatusBarHeightVm } from '@ohos/systemuicommon/src/main/ets/statusbar/vm/StatusBarHeightVm';
import { CutoutLayout } from '@ohos/systemuicommon/src/main/ets/notification/interface/INotificationClearButtonVm';
import { OutdoorVm } from '@ohos/systemuicommon/src/main/ets/vm/OutdoorVm';

const TAG = 'NotificationClearButtonVm';
const log = LogHelper.getLogHelper(LogDomain.NC, TAG);
const LIST_ITEM_SPACE = 8;
const NTF_MORE_HEADER_TAG = 'NotificationListView_MoreHeader';
const UNKNOWN_DELETED_NUMBER = 65535;
const HIDE_PANEL_DELAY = 417;
const MORE_NTF_COLLAPSE_DELAY = 333;

/**
 * 一键清除按钮管理
 *
 * @since 2024-11-20
 */
@ObservedV2
export class NotificationClearButtonVm extends NotificationBaseVm implements INotificationClearButtonVm {
  @Trace public cutoutLayout: CutoutLayout | undefined = undefined;
  /**
   * 一键清除按钮的缩放值
   */
  @Trace public scale: number = 1;
  /**
   * 一键清除按钮的旋转度
   */
  @Trace public angle: number = 0;

  /**
   * 实时背景模糊参数
   */
  @Trace public backgroundEffectOptions?: BackgroundEffectOptions = this.vmInjector.getColorVm().ntfClearButtonBgEffect;

  public marginBottom = LengthMetrics.resource($r('app.float.ntf_clear_btn_padding'));
  /**
   * 是否在一键清除
   */
  @Trace public isClearingAll: boolean = false;
  /**
   * 一键删除向上移动item的index
   */
  private moveUpwardItemIndexList: number[] = [];
  /**
   * 一键删除向下移动item的index
   */
  private moveDownwardItemIndexList: number[] = [];
  /**
   * 一键删除向上移动item的目标bottomY值
   */
  private targetBottomY: number = 0;
  /**
   * 一键删除向上移动item的动效延迟
   */
  private upwardItemDelay: number = 0;

  /**
   * 待清除的通知列表
   * @returns
   */
  @Computed protected get pendingClearNtfList(): NotificationBase[] {
    const listVm = this.vmInjector.getListVm?.();
    const ntfList = listVm ? listVm.mainNtfList.concat(listVm.moreNtfList) : [];
    return this.getClearNtfList(ntfList);
  }

  protected getClearNtfList(ntfList: NotificationBase[]) {
    const clearNtfList: NotificationBase[] = [];

    for (const ntf of ntfList) {
      if (!ntf.isNormalGroup()) {
        if (this.isClearable(ntf)) {
          clearNtfList.push(ntf);
        }
        continue;
      }
      for (const child of ntf.children) {
        if (this.isClearable(child)) {
          clearNtfList.push(child);
        }
      }
    }
    log.showInfo(`Pending clear ntf list length: ${clearNtfList.length}`);
    return clearNtfList;
  }

  /**
   * 是否显示清除按钮
   * @returns
   */
  @Computed get isShow(): boolean {
    return this.pendingClearNtfList.length > 0;
  }

  private animation = new NotificationClearAllAnimation();

  public setCutoutLayout(cutoutLayout?: CutoutLayout): void {
    this.cutoutLayout = cutoutLayout;
  }

  @Computed
  get margin(): Margin | LocalizedMargin {
    if (this.vmInjector.getPanelVm().isLandscapeLayout) {
      return {
        end: LengthMetrics.vp(this.cutoutLayout ? this.cutoutLayout.clearBtnMarginEnd : 0),
        // 横屏一键删除按钮，需要去除状态栏居中对齐
        top: LengthMetrics.vp(StatusBarHeightVm.getInstance().getAvoidHeight()),
        bottom: LengthMetrics.resource($r('app.float.ntf_none_vp'))
      };
    }
    return { right: 0, bottom: this.marginBottom };
  }

  @Computed
  get alignRules(): LocalizedAlignRuleOptions {
    if (this.vmInjector.getPanelVm().isLandscapeLayout) {
      return {
        end: { anchor: '__container__', align: HorizontalAlign.End },
        center: { anchor: '__container__', align: VerticalAlign.Center }
      };
    }
    return {
      bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
      middle: { anchor: '__container__', align: HorizontalAlign.Center }
    };
  }

  @Computed
  get width(): string | Resource {
    if (this.vmInjector.getPanelVm().isLandscapeLayout) {
      return this.cutoutLayout ? CommonUtils.spliceVp(this.cutoutLayout.clearBtnWidth) :
        `calc(37.5% - ${NotificationStyle.LANDSCAPE_HEAD_VIEW_WIDTH})`;
    }
    return $r('app.float.ntf_clear_button_icon_size');
  }

  public registerEventListener(): void {
  }

  public unRegisterEventListener(): void {
  }

  /**
   * 修改一键清除按钮的属性
   *
   * @param scale 缩放
   * @param angle 翻转
   */
  updateClearButtonParams(scale?: number, angle?: number): void {
    if (scale !== undefined) {
      this.scale = scale;
    }
    if (angle !== undefined) {
      this.angle = angle;
    }
  }

  /**
   * 开关背景模糊
   */
  enableBackgroundEffect(enable: boolean): void {
    if (enable) {
      this.backgroundEffectOptions = this.vmInjector.getColorVm().ntfClearButtonBgEffect;
    } else {
      this.backgroundEffectOptions = undefined;
    }
  }

  /**
   * 清除通知
   */
  clear(): void {
    const listVm = this.vmInjector.getListVm?.();
    const scrollerVm = this.vmInjector.getListScrollerVm?.();
    const moreHeaderVm = this.vmInjector.getNotificationMoreHeaderVm();
    if (!listVm) {
      return;
    }

    const scroller: Scroller | undefined = scrollerVm?.scroller;
    if (scroller) {
      scroller.scrollTo({
        xOffset: scroller.currentOffset().xOffset,
        yOffset: scroller.currentOffset().yOffset,
        animation: { duration: 0, canOverScroll: true }
      });
    }

    NotificationDataManager.instance.freeze(NotificationDataManager.REASON.DROPDOWN_REMOVE, 1000);
    this.isClearingAll = true;
    this.enableBackgroundEffect(false);
    const startIndex = scrollerVm?.startIndex ?? 0;
    const endIndex = scrollerVm?.endIndex ?? 0;

    this.initAnimationParams();
    this.separateItemIndexList(startIndex, endIndex, listVm);

    this.addDownwardAnimation(listVm);
    this.addUpwardAnimation(listVm);

    if (moreHeaderVm) {
      moreHeaderVm.isInClearAllAnim = true;
    }
    for (let i = startIndex; i <= endIndex; i++) {
      const ntf = listVm.getListItemByIndex(i);
      if (!ntf) {
        continue;
      }
      this.vmInjector.getCardVm(ntf).isInClearAllAnim = true;
    }

    this.animation.addClearButtonAnimation(this);
    if (this.vmInjector.getMoreVm()?.isExtraNtfsCollapseStatusChanging &&
    NotificationMoreHeaderModel.instance.isCollapsed) {
      setTimeout(() => this.startClearAnimation(moreHeaderVm), MORE_NTF_COLLAPSE_DELAY);
      setTimeout(() => this.deleteNtfAndHidePanel(), HIDE_PANEL_DELAY + MORE_NTF_COLLAPSE_DELAY);
    } else {
      this.startClearAnimation(moreHeaderVm);
      setTimeout(() => this.deleteNtfAndHidePanel(), HIDE_PANEL_DELAY);
    }
  }

  private deleteNtfAndHidePanel(): void {
    try {
      log.showInfo(`Start clear all notification, size: ${this.pendingClearNtfList.length}`);
      DropdownVm.instance.hidePanel(true);
      setTimeout(() => {
        NotificationDataManager.instance.unfreeze(NotificationDataManager.REASON.DROPDOWN_REMOVE);
        NotificationApiUtil.removeNtfByCancel(this.pendingClearNtfList);
        HiDfxEventUtil.reportDeleteAllNotification();
        this.reportClearAllData();
      }, 400);
      log.showInfo(`End clear all notification, clear size ${this.pendingClearNtfList.length}`);
    } catch (e) {
      log.error('Clear all notification error:', e);
    }
  }

  /**
   * 一键清除通知数量运营打点
   */
  private reportClearAllData(): void {
    let unknownNtfCount = 0;
    let socialNtfCount = 0;
    let serviceNtfCount = 0;
    let contentNtfCount = 0;
    let allNtfCount = 0;

    for (const ntf of this.pendingClearNtfList) {
      allNtfCount += 1;
      if (ntf.slotType === UNKNOWN_DELETED_NUMBER) {
        unknownNtfCount += 1;
      } else if (ntf.slotType === notificationManager.SlotType.SOCIAL_COMMUNICATION) {
        socialNtfCount += 1;
      } else if (ntf.slotType === notificationManager.SlotType.SERVICE_INFORMATION) {
        serviceNtfCount += 1;
      } else if (ntf.slotType === notificationManager.SlotType.CONTENT_INFORMATION) {
        contentNtfCount += 1;
      }
    }
    NotificationSysEventReporter.notificationPanelClear({
      TIME_STAMP: `${DropDownPanelManager.getLastDropdownTime()}`,
      UNKNOWN_DELETED_NUMBER: unknownNtfCount,
      SOCIAL_DELETED_NUMBER: socialNtfCount,
      SERVICE_DELETED_NUMBER: serviceNtfCount,
      CONTENT_DELETED_NUMBER: contentNtfCount,
      DELETED_NUMBER: allNtfCount
    });
  }

  private isClearable(ntf: NotificationBase): boolean {
    return ntf.isClearAllowed && DeviceInfoVm.instance.isShowNotification(ntf.creatorBundleName) &&
      OutdoorVm.instance.isInOutdoorAppList(ntf);
  }

  /**
   * 一键清除，更多通知标题是否向下移动
   * @returns 可视区域内，只要有一条不能删除的更多通知，返回false
   */
  private isMoreHeaderDisappear(startIndex: number, endIndex: number): boolean {
    const listVm = this.vmInjector.getListVm();
    for (let i = startIndex; i < endIndex + 1; i++) {
      const ntf = listVm?.getListItemByIndex(i);
      if (ntf?.isMoreNtf() && !ntf.isClearAllowed) {
        return false;
      }
    }
    return true;
  }

  /**
   * 一键清除，初始化动效需要的成员变量
   */
  private initAnimationParams(): void {
    const listId = this.vmInjector.getId('NotificationListComponent');
    const listRectTop = ItemUtils.getRectById(listId)?.top;
    this.moveUpwardItemIndexList = [];
    this.moveDownwardItemIndexList = [];
    this.targetBottomY = listRectTop + (this.vmInjector.getListVm()?.contentStartOffset ?? 0);
    this.upwardItemDelay = 0;
    this.animation.isLandscapeLayout = DeviceInfoVm.instance.isLandscape;
    log.showInfo(`initAnimationParams, isLandscape = ${this.animation.isLandscapeLayout} `)
  }

  /**
   * 一键清除，区分通知列表可视区域中，item的动效移动方向
   *
   * @param startIndex 可视区域第一个item的index
   * @param endIndex 可视区域最后一个item的index
   * @param listVm
   */
  private separateItemIndexList(startIndex: number, endIndex: number, listVm: INotificationListVm): void {
    this.moveUpwardItemIndexList = [];
    this.moveDownwardItemIndexList = [];
    for (let i = startIndex; i <= endIndex; i++) {
      const isMoreHeader: boolean = i === listVm.mainNtfList.length;
      const ntf = listVm.getListItemByIndex(i);
      if (!ntf) {
        continue;
      }
      if (isMoreHeader) {
        const isMoreHeaderDisappear: boolean = this.isMoreHeaderDisappear(startIndex, endIndex);
        if (isMoreHeaderDisappear) {
          this.moveDownwardItemIndexList.push(i);
        } else {
          this.moveUpwardItemIndexList.push(i);
        }
      } else {
        if (ntf.isClearAllowed) {
          this.moveDownwardItemIndexList.push(i);
        } else {
          this.moveUpwardItemIndexList.push(i);
        }
      }
    }
  }

  /**
   * 一键清除，添加向上位移item的动效
   *
   * @param listVm
   */
  private addUpwardAnimation(listVm: INotificationListVm): void {
    if (this.moveUpwardItemIndexList.length === 0) {
      return;
    }
    this.moveUpwardItemIndexList.forEach((itemIndex, index) => {
      const ntf = listVm.getListItemByIndex(itemIndex);
      if (!ntf) {
        return;
      }
      const isMoreHeader: boolean = itemIndex === listVm.mainNtfList.length;
      const itemId: string = isMoreHeader ? this.vmInjector.getId(NTF_MORE_HEADER_TAG) : listVm.getItemId(ntf);
      const itemRect = ItemUtils.getRectById(itemId);
      const itemHeight: number = itemRect.height ?? 0;
      this.targetBottomY += itemHeight + (index === 0 ? 0 : LIST_ITEM_SPACE);
      log.showInfo(`Clear all animation, item upward, index = ${itemIndex}, ` +
        ` delay = ${this.upwardItemDelay}, transY = ${this.targetBottomY - itemRect.bottom}`)
      if (itemIndex === listVm.mainNtfList.length) {
        const moreHeaderVm = this.vmInjector.getNotificationMoreHeaderVm();
        if (moreHeaderVm) {
          this.animation.addMoreHeaderAnimationUpwards({
            delay: this.upwardItemDelay,
            moreHeaderVm: moreHeaderVm,
            translateY: this.targetBottomY - itemRect.bottom,
          });
        }
      } else {
        // 动效开始之前将不可删除卡片裁剪置为true
        this.vmInjector.getCardVm(ntf).containerClip = true;
        this.vmInjector.getCardVm(ntf).contentClipParam = true;
        this.animation.addListItemAnimationUpwards({
          index: index,
          itemId: listVm.getItemId(ntf),
          delay: this.upwardItemDelay,
          cardVm: this.vmInjector.getCardVm(ntf),
          translateY: this.targetBottomY - itemRect.bottom,
        });
      }
    });
  }

  /**
   * 一键清除，添加向下位移item的动效
   *
   * @param listVm
   */
  private addDownwardAnimation(listVm: INotificationListVm) {
    if (this.moveDownwardItemIndexList.length === 0) {
      return;
    }
    this.moveDownwardItemIndexList.forEach((itemIndex, index) => {
      const ntf = listVm.getListItemByIndex(itemIndex);
      if (!ntf) {
        return;
      }
      const delayTime: number =
        (this.moveDownwardItemIndexList.length - 1 - index) * NotificationClearAllAnimation.delayPerItem +
        NotificationClearAllAnimation.clearButtonAniDuration;
      log.showInfo(`Clear all animation, item downward, index = ${itemIndex}, delay = ${delayTime}`)
      if (index === 0) {
        this.upwardItemDelay = delayTime;
      }
      if (itemIndex === listVm.mainNtfList.length) {
        const moreHeaderVm = this.vmInjector.getNotificationMoreHeaderVm();
        if (moreHeaderVm) {
          this.animation.addMoreHeaderDisappearAnimation({
            delay: delayTime,
            moreHeaderVm: moreHeaderVm,
          });
        }
      } else {
        this.animation.addListItemAnimationDownwards({
          index: index,
          itemId: listVm.getItemId(ntf),
          delay: delayTime,
          cardVm: this.vmInjector.getCardVm(ntf),
        });
      }
    });
  }

  private startClearAnimation(moreHeaderVm: INotificationMoreHeaderVm | undefined): void {
    this.animation.startAnimation().then(() => {
      if (moreHeaderVm) {
        moreHeaderVm.isInClearAllAnim = false;
      }
      log.showInfo('ClearNtAni/IntoNC All notification animation finish, mark renderGroup false.');
    });
  }
}