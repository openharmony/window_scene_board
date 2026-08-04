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

import {
  NotificationBase,
  NotificationEvent,
  NotificationArray,
  NotificationCategory,
  LiveCardFlightModel,
  NormalNotification,
  NormalNotificationGroup,
} from '@ohos/systemuicommon/newTsIndex';
import {
  AnimationBase,
  INotificationListVm,
  DeviceInfoVm,
  DropdownVm,
  LiveNotification,
  AccessibilityVm,
  DropDownPanelManager,
} from '@ohos/systemuicommon/newIndex';
import { LiveDropdownVmInjector } from '@ohos/systemuicommon/src/main/ets/live/variant/dropdown/LiveDropdownVmInjector';
import { NotificationSwipeVm } from './NotificationSwipeVm';
import { NotificationConfig } from '../common/NotificationConfig';
import { NotificationNormalVm } from './NotificationNormalVm';
import { NotificationDataVm } from './NotificationDataVm';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { DeviceHelper, DropDownEvent, TargetPanel } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { ItemUtils } from '@ohos/componenthelper/src/main/ets/TsIndex';
import { IUpdateParam, UpdateType } from '@ohos/systemuicommon/src/main/ets/notification/interface/INotificationListVm';
import { ArkUIAdapter } from '@ohos/systemuicommon/src/main/ets/utils/ArkUIAdapter';
import { NotificationStatusBarEventManager } from '../manager/NotificationStatusBarEventManager';
import { ResUtils } from '@ohos/windowscene';
import { DISABLE_HEAD_BLUR_EFFECT } from '@ohos/systemuicommon/src/main/ets/template/common/SCBVisualEffectOption';
import { SystemUICommonUtil } from '@ohos/systemuicommon';
import { DeviceModeEnum } from '@ohos/commonconstants';
import { NotificationStyle } from '../constants/NotificationStyle';
import { NtfAnimationConsts } from '../common/NtfAnimationConsts';
import { performanceMonitor } from '@kit.ArkUI';
import { OutdoorVm } from '@ohos/systemuicommon/src/main/ets/vm/OutdoorVm';

const TAG = 'NotificationListVm';
const log = LogHelper.getLogHelper(LogDomain.NC, TAG);
/**
 * PAD、折叠屏宽度固定值vp
 */
const LAND_PAD_OR_FOLD_NTF_WIDTH: string = '532vp';
/**
 * 透明卡片高度
 */
const TRANSPARENT_CARD_HEIGHT: number = 88;
/**
 * 更多通知超过两条折叠时透明卡片高度
 */
const TRANSPARENT_CARD_HEIGHT_WHEN_COLLAPSED: number = 550;
/**
 * 可横滑切换双中心的透明度阈值
 */
const SWITCH_MIN_OPACITY: number = 0.8;

/**
 * 应急模式切换时，通知更新的延迟，等待面板收起后再更新
 */
const DEVICE_MODE_CHANGE_NTF_DELAY = 420;

/**
 * 通知更新或置顶时的动画时长
 */
const NTF_UPDATE_ANIMATION_DURATION = 350;
const LIST_COMPONENT_TAG: string = 'NotificationListComponent';
/**
 * 流量显示组件到列表顶部的距离
 */
const DATA_PLAN_MARGIN_BOTTOM = 8;
/**
 * 需要更新堆叠参数的数据操作类型
 */
const NEED_TRANSFORM_UPDATE_TYPE = new Set(
  [UpdateType.ADD_OR_UPDATE, UpdateType.DELETE_BATCH, UpdateType.DELETE_SINGLE, UpdateType.DELETE_CHILD]);

@ObservedV2
export class NotificationListVm extends NotificationDataVm implements INotificationListVm {
  /**
   * 主通知列表
   */
  @Trace public readonly mainNtfList: NotificationArray = new NotificationArray();
  /**
   * 更多通知列表
   */
  @Trace public readonly moreNtfList: NotificationArray = new NotificationArray();
  /**
   * 列表裁切
   */
  @Trace public clipShape: PathAttribute | undefined = undefined;
  /**
   * 列表整体的Y轴偏移量，用于下拉跟手动效
   */
  @Trace public translateY: number = 0;
  /**
   * 松手回弹动效
   */
  public reboundAnim: AnimateParam | null = null;
  /**
   * 是否正在更新数据
   */
  @Trace public isDataUpdating: boolean = false;
  /**
   * 是否正在展开组通知
   */
  @Trace public isGroupExpanding: boolean = false;
  /**
   * 需要懒加载的通知
   */
  public ntfCacheMap: Map<string, NotificationBase> = new Map<string, NotificationBase>();
  /**
   * 本次事件是否为更新事件(仅面板不显示时有效)
   */
  private isUpdateEvent: boolean = false;
  /**
   * 下拉事件
   */
  private dropdownEvent: DropDownEvent = DropdownVm.instance.dropdownEvent;
  /**
   * 是否展示底部透明卡片
   */
  public isShowBottomTransCard: boolean = true;
  /**
   * 设备信息
   */
  protected deviceInfoVm = DeviceInfoVm.instance;
  /**
   * 标志收起通知面板时，是否需要更新通知列表
   */
  private needCollapseUpdate: boolean = false;
  /**
   * 直接更新数据
   */
  private isNeedUpdate = false;

  /**
   * 通知面板点击事件
   *
   * @param event 点击事件
   */
  public onClick = (event: ClickEvent): void => {
    const endIndex = this.vmInjector.getListScrollerVm()!.endIndex;
    const actualEndIndex =
      this.isShowBottomTransCard && endIndex > this.getMaxIndex() ? this.getMaxIndex() : endIndex; //移除透明卡片
    if (this.isInNtfVisibleList(event.displayY, event.displayX, actualEndIndex)) {
      // 点击在通知卡片之间的间隙，面板不收起
      return;
    }
    log.showInfo('onClick, hide panel');
    DropdownVm.instance.hidePanel(true);
  }
  /**
   * 云端模式
   */
  protected outdoorVm = OutdoorVm.instance;
  /**
   * 面板隐藏时，如果组通知只有一条通知则取消组通知
   * @returns
   */
  @Computed
  get isPanelVisible(): boolean {
    return this.vmInjector.getPanelVm().isVisible;
  }

  @Computed
  get isDropDownShow(): boolean {
    return DropdownVm.instance.isShow;
  }

  @Trace public layoutWeight = 1;
  @Trace public emptyTextHeight = 'auto';
  @Trace public emptyTextOffset: Position = {};
  @Trace public alignRules: LocalizedAlignRuleOptions = {
    top: { anchor: '__container__', align: VerticalAlign.Top },
    middle: { anchor: '__container__', align: HorizontalAlign.Center }
  };
  @Trace public transparentCardHeight: number = TRANSPARENT_CARD_HEIGHT;

  @Computed
  get portraitMargin(): Margin {
    if (DeviceHelper.isPad()) {
      return {
        bottom: DeviceInfoVm.instance.isLandscape ? $r('app.float.ntf_list_land_item_padding_bottom')
          : $r('app.float.ntf_list_item_padding_bottom'),
      }
    }
    return {
      left: $r('app.float.ntf_list_item_padding_start_end'),
      right: $r('app.float.ntf_list_item_padding_start_end'),
      bottom: $r('app.float.ntf_list_item_padding_bottom'),
      top: 0,
    };
  }

  @Computed
  get margin(): Margin {
    return this.vmInjector.getPanelVm().isLandscapeLayout ? this.landscapeMargin : this.portraitMargin;
  }

  /**
   * 根据屏幕宽度及屏幕状态计算内容宽度
   * 1、PAD、折叠屏展开态固定宽度
   * 2、直板机、折叠屏折叠态横屏状态下取值采用栅格方式计算
   * 3、其他（平板手机竖屏、折叠态竖屏）：宽度占满全屏
   *
   * @returns 通知列表宽度
   */
  @Computed
  get portraitWidth(): string {
    if (DeviceHelper.isPad() ||
      (DeviceInfoVm.instance.isExpand)) {
      return LAND_PAD_OR_FOLD_NTF_WIDTH;
    }
    return '100%';
  }

  @Computed
  get width(): string {
    return this.vmInjector.getPanelVm().isLandscapeLayout ? this.landscapeWidth : this.portraitWidth;
  }
  /**
   * 如果是横屏且需要展示流量信息，则列表高度需要减去流量组件+距离列表第一张卡片8vp的margin高度
   */
  @Computed
  get height(): string {
    return (this.vmInjector.getPanelVm().isLandscapeLayout && this.vmInjector.getDataPlanVm()?.isShowDataPlan) ?
      `calc(100% - ${((this.vmInjector.getDataPlanVm()?.getTextHeight() ?? 0) + DATA_PLAN_MARGIN_BOTTOM)}vp)` : `100%`;
  }

  @Computed
  get scale(): ScaleOptions | undefined {
    return undefined;
  }

  @Computed
  get contentStartOffset(): number {
    if (this.vmInjector.getPanelVm().isLandscapeLayout) {
      const startOffset = ResUtils.getNumber($r('app.float.status_bar_phone_height'));
      const dataPlanHeight = this.vmInjector.getDataPlanVm()?.getTextHeight() ?? 0
      //通知中心无通知时，emptyTextOffset应等于流量显示组件偏移量加上本身组件高度的一半
      const emptyDataOffset =
        startOffset + dataPlanHeight + 2 * ResUtils.getNumber($r('app.float.data_plan_margin_bottom'));
      const textOffset = this.vmInjector.getDataPlanVm()?.isShowDataPlan ? emptyDataOffset : startOffset
      this.emptyTextOffset = { y: -textOffset / 2 };
      return startOffset;
    }
    this.emptyTextOffset = {};
    return ResUtils.getNumber($r('app.float.status_bar_phone_height')) + (this.vmInjector.getHeaderVm()?.headerHeight ?? 0);
  }

  @Monitor('contentStartOffset')
  contentStartOffsetChange(): void {
    log.showInfo('contentStartOffset change');
    this.vmInjector.getListScrollerVm()?.scrollToTop();
  }

  @Computed
  get isScrollEnable(): boolean {
    // 横屏且列表为空，显示“没有通知”，列表不能滑动
    return !(this.vmInjector.getPanelVm().isLandscapeLayout && this.isEmpty);
  }

  /**
   * 初始化
   */
  init(): void {
    log.showInfo('Init');
    super.init();
    this.vmInjector.getPanelVm().emitter?.on('isLandscapeLayout', this.isLandscapeLayoutChange);
    this.vmInjector.getPanelVm().emitter?.on('isGroupExpanding', this.isGroupExpandingChange);
  }

  /**
   * 销毁
   */
  destroy(): void {
    log.showInfo('Destroy');
    super.destroy();
    this.vmInjector.getPanelVm().emitter?.off('isLandscapeLayout', this.isLandscapeLayoutChange);
    this.vmInjector.getPanelVm().emitter?.off('isGroupExpanding', this.isGroupExpandingChange);
    // 清空数据
    this.ntfCacheMap.clear();
  }

  /**
   * 面板不可见时，允许解除组通知
   *
   * @returns true解除组通知
   */
  protected isResetGroup(): boolean {
    return !this.isPanelVisible;
  }

  /**
   * 通知列表是否为空
   * @returns
   */
  @Computed
  get isEmpty(): boolean {
    return this.mainNtfList.length + this.moreNtfList.length === 0;
  }

  @Computed
  get displayedMoreNtfList(): NotificationBase[] {
    const moreVm = this.vmInjector.getMoreVm?.();
    if (this.vmInjector.getNotificationMoreHeaderVm()?.isCollapsed && this.moreNtfList.length > 0) {
      return [this.moreNtfList[0]];
    }
    return this.moreNtfList;
  }

  public updateTransparentCardHeight(isExtraNtfsCollapseStatusChanging: boolean): void {
    if (!isExtraNtfsCollapseStatusChanging) {
      animateTo({ duration: 333, curve: NtfAnimationConsts.GROUP_ITEM_EXPAND_CURVE, }, () => {
        this.transparentCardHeight = this.vmInjector.getPanelVm().isLandscapeLayout ? 1 : TRANSPARENT_CARD_HEIGHT;
      })
      return;
    }
    // 增加空白卡片高度
    const scrollEndIndex = this.vmInjector.getListScrollerVm()?.endIndex ?? 0;
    const listLength = this.mainNtfList.length + this.moreNtfList.length;
    const showMoreItemLength =
      this.isShowBottomTransCard && scrollEndIndex > listLength ? this.moreNtfList.length + 1 : this.moreNtfList.length;
    if (showMoreItemLength > 2) {
      this.transparentCardHeight = TRANSPARENT_CARD_HEIGHT_WHEN_COLLAPSED;
    }
  }

  /**
   * 根据Index获取通知信息
   *
   * @param index 通知索引值
   * @returns 通知信息
   */
  getListItemByIndex(index: number, ignoreMoreHeader?: boolean): NotificationBase | undefined {
    const maxIndex = this.getMaxIndex();
    if (index < 0 || index > maxIndex) {
      return undefined;
    }
    if (index < this.mainNtfList.length) {
      return this.mainNtfList[index];
    }
    if (index === this.mainNtfList.length) {
      return ignoreMoreHeader ? undefined : this.moreNtfList[0];
    }
    return this.moreNtfList[index - this.mainNtfList.length - 1];
  }

  /**
   * 是否更多通知header的index
   * @param index
   * @returns
   */
  isMoreHeaderIndex(index: number): boolean {
    const maxIndex = this.getMaxIndex();
    if (index >= 0 && index < maxIndex && index === this.mainNtfList.length) {
      return true;
    }

    return false;
  }

  /**
   * 根据通知信息获取index
   *
   * @param ntf 通知信息
   * @returns index
   */
  getListItemIndex(ntf: NotificationBase): number {
    for (let i = 0; i < this.mainNtfList.length; i++) {
      if (ntf.hashCode === this.mainNtfList[i].hashCode) {
        return i;
      }
    }
    for (let i = 0; i < this.moreNtfList.length; i++) {
      if (ntf.hashCode === this.moreNtfList[i].hashCode) {
        return this.mainNtfList.length + 1 + i;
      }
    }
    return -1;
  }

  /**
   * 列表高度变化
   *
   * @param size
   */
  onListSizeChange(size: SizeOptions): void {
    const r = ArkUIAdapter.vp2px(NotificationConfig.BORDER_RADIUS);
    const width = ArkUIAdapter.vp2px(Number(size.width));
    const height = ArkUIAdapter.vp2px(Number(size.height));
    const overWidth = ArkUIAdapter.vp2px(50);
    this.clipShape = new Path({ commands: this.getClipShapeCommands(r, width, height, overWidth) });
  }

  /**
   * 处理通知事件
   *
   * @param event 事件
   */
  protected handleNotificationEvent(event: NotificationEvent): void {
    if (!this.isPanelVisible) {
      // 更新事件只处理ANS发送的事件
      this.isUpdateEvent = event.eventType === NotificationEvent.EVENT_TYPE_UPDATE &&
        (event.updateType === NotificationEvent.UPDATE_TYPE_ANS);
      // 面板不可见时,无需执行动效,直接更新数据即可
      this.isNeedUpdate = true;
      super.handleNotificationEvent(event);
      if (!this.isNeedUpdate) {
        // 直接发送状态栏图标
        this.postStatusBarEventDirectly();
      } else {
        this.updateNtf({ updateType: UpdateType.ADD_OR_UPDATE });
        this.vmInjector.getListScrollerVm()?.transform();
      }
      this.isUpdateEvent = false;
      return;
    }

    const needDeleteChainAnimNtf = this.getNeedDeleteChainAnimNtf(event);
    if (needDeleteChainAnimNtf) {
      // 使用setTimeout规避await和状态管理v2的动效下发bug
      setTimeout(() => {
        this.deleteNtfList(needDeleteChainAnimNtf, event);
      }, 0)
    } else {
      this.setUpdateItemIndexToTop(event);
      const isSaveGroupNtf = this.getIsSaveGroupNtf(event);
      super.handleNotificationEvent(event);
      if (isSaveGroupNtf) {
        this.disableSaveGroupTransition(event);
      }

      // 置顶场景先下树再出场，避免repeat复用导致动效异常，在event中执行出场动效，防止动效合并
      if (event.updateType === NotificationEvent.UPDATE_TYPE_PIN_TOP) {
        this.executePinTopAnim(event, isSaveGroupNtf);
        return;
      }

      this.executeUpdateAnim(event, isSaveGroupNtf);
    }
  };

  /**
   * 天气背景更新时，不需要更新动效
   * @param event
   * @returns
   */
  private checkLiveUpdateDuration(event: NotificationEvent): number {
    if (event.eventType !== NotificationEvent.EVENT_TYPE_UPDATE || event.isBatch || !event.notificationList.length) {
      return NTF_UPDATE_ANIMATION_DURATION;
    }
    const ntf = event.notificationList[0];
    if (ntf.isLiveView() && ntf.card.isFlightCard()) {
      const isUpdate = (ntf.card as LiveCardFlightModel).liveCardWeatherInfo?.isUpdateAnimation;
      return isUpdate ? 0 : NTF_UPDATE_ANIMATION_DURATION;
    }
    return NTF_UPDATE_ANIMATION_DURATION;
  }

  private isInNtfVisibleList(displayY: number, displayX: number, itemIndex: number): boolean {
    const lastNtf = this.getListItemByIndex(itemIndex);
    const firstNtf = this.getListItemByIndex(this.vmInjector.getListScrollerVm()?.startIndex ?? 0);
    if (!lastNtf || !firstNtf) {
      return false;
    }
    const lastNtfRectInfo = ItemUtils.getRectById(this.getItemId(lastNtf));
    const cardVm = this.vmInjector.getCardVm(lastNtf);
    let rectBottom = cardVm.opacity < 1 ? lastNtfRectInfo.bottom + cardVm.translateY : lastNtfRectInfo.bottom;
    // 取列表底边与最后一个卡片底边的最小值
    const listRectInfo = ItemUtils.getRectById(this.vmInjector.getId(LIST_COMPONENT_TAG))
    rectBottom = rectBottom > listRectInfo.bottom ? listRectInfo.bottom : rectBottom;

    const firstNtfRectInfo = ItemUtils.getRectById(this.getItemId(firstNtf));
    return displayY >= firstNtfRectInfo.top && displayY <= rectBottom && displayX >= firstNtfRectInfo.left &&
      displayX <= firstNtfRectInfo.right;
  }

  private executePinTopAnim(event: NotificationEvent, isSaveGroupNtf: boolean) {
    new AnimationBase(AnimationBase.NAMES.NTF_LIST_ANIMATION, true).executeAnimation([{
      curve: Curve.Friction,
      duration: NTF_UPDATE_ANIMATION_DURATION,
      event: () => {
        this.updateNtf({ updateType: UpdateType.ADD_OR_UPDATE, ignoreNtfArr: event.notificationList });
        this.executeUpdateAnim(event, isSaveGroupNtf);
      },
    }]);
  }

  private executeUpdateAnim(event: NotificationEvent, isSaveGroupNtf: boolean) {
    this.isDataUpdating = true;
    const isPanelDismissing = DropDownPanelManager.isPanelDismissing();
    this.startUpdateNtfListReport(event.eventType, isPanelDismissing);
    new AnimationBase(AnimationBase.NAMES.NTF_LIST_ANIMATION, false, true).executeAnimationSync([{
      curve: Curve.Friction,
      duration: this.checkLiveUpdateDuration(event),
      event: () => {
        if (event.eventType !== NotificationEvent.EVENT_TYPE_REMOVE) {
          this.updateNtf({ updateType: UpdateType.ADD_OR_UPDATE, updateNtfList: event.notificationList });
        } else if (this.isDeleteCollapsedMoreNtf(event)) {
          // 删除折叠的更多通知
          this.updateNtf({ updateType: UpdateType.DELETE_MORE_BRIEF })
        } else if (event.notificationList?.length === 1) {
          // 删除组通知内非最后一条子通知
          this.updateNtf({ updateType: UpdateType.DELETE_CHILD, updateNtfList: event.notificationList });
        } else {
          this.updateNtf({ updateType: UpdateType.DELETE_BATCH, updateNtfList: event.notificationList });
        }
      },
      onFinish: () => {
        this.endUpdateNtfListReport(event.eventType, isPanelDismissing);
        if (isSaveGroupNtf) {
          this.disableSaveGroupTransition(event, true);
        }
        this.isDataUpdating = false;
      }
    }]);
  }

  private setUpdateItemIndexToTop(event: NotificationEvent): void {
    const currentGroupNtf = event.notificationList[0];
    if (this.isPanelVisible && currentGroupNtf) {
      const groupNtf = this.getNtfByGroupKey(currentGroupNtf.groupKey);
      if (groupNtf) {
        const ntfList = new NotificationArray();
        if (groupNtf.isMoreNtf()) {
          ntfList.push(...this.moreNtfList);
        } else {
          ntfList.push(...this.mainNtfList);
        }
        const preIndex = ntfList.findIndex(ntf => ntf === groupNtf);
        ntfList.splice(preIndex, 1, currentGroupNtf);
        const curIndex = ntfList.sort().findIndex(ntf => ntf === currentGroupNtf);
        log.showInfo(`updateItemIndex, preIndex: ${preIndex}, curIndex: ${curIndex} `);
        // 原地更新不改变zIndex，避免卡片堆叠时闪
        if (preIndex !== curIndex) {
          this.vmInjector.getCardVm(groupNtf).zIndex = 2;
        }
      }
    }
  }

  private deleteNtfList(ntf: NotificationBase, event: NotificationEvent): void {
    const index = this.getListItemIndex(ntf);

    let isDeletingGroup: boolean = true;
    const groupKey: string = event.notificationList[0].groupKey;
    const group = this.getGroupNtf(event.notificationList[0]);
    event.notificationList.forEach((ntf) => {
      if (ntf.groupKey !== groupKey) {
        isDeletingGroup = false;
      }
    })

    let updateType = UpdateType.DELETE_GROUP;

    if (!isDeletingGroup) {
      updateType = UpdateType.CLEAR_ALL;
    } else if (group && event.notificationList.length === 1) {
      updateType = UpdateType.DELETE_CHILD;
    } else if (group && event.notificationList.length > 1) {
      updateType = UpdateType.DELETE_GROUP;
    } else {
      updateType = UpdateType.DELETE_SINGLE;
    }

    const doDelete = () => {
      // 单个删除场景，降低待删除卡片层级，避免其他卡片链式动效移动过来时显示重叠
      if (updateType === UpdateType.DELETE_SINGLE) {
        this.vmInjector.getCardVm(ntf).zIndex = 0;
      }

      animateTo({ duration: 0 }, () => {
        super.handleNotificationEvent(event);
        this.updateNtf({
          updateType: updateType,
          updateNtfList: event.notificationList,
          ignoreTransform: true
        });
      })
    }
    this.vmInjector.getListScrollerVm()?.doDeleteChainAnimation(ntf, index, doDelete);
  }

  private getNeedDeleteChainAnimNtf(event: NotificationEvent): NotificationBase | undefined {
    if (event.eventType !== NotificationEvent.EVENT_TYPE_REMOVE) {
      return undefined;
    }
    const ntf = event.notificationList[0];
    // 面板中忽略不显示通知，删除时不做链式动效（如即时类实况）
    if (this.isExcludedNtf(ntf)) {
      return undefined;
    }

    const groupNtf = this.getGroupNtf(ntf);
    if (this.isDeleteCollapsedMoreNtf(event)) {
      return groupNtf ?? ntf;
    }
    // 删除单通知和删除组通知时需要链式补位动效，删除组通知内的子通知不需要
    if (!groupNtf) {
      // 批量删除时不做链式动效
      return this.isNotInNotificationVisibleList(ntf) || event.notificationList.length > 1 ? undefined : ntf;
    } else if (groupNtf.children.length === event.notificationList.length) {
      return groupNtf;
    } else {
      return undefined;
    }
  }

  private isNotInNotificationVisibleList(ntf: NotificationBase): boolean {
    const scrollerVm = this.vmInjector.getListScrollerVm();
    if (!scrollerVm) {
      return true;
    }
    const index = this.getListItemIndex(ntf);
    const startIndex = scrollerVm.startIndex;
    const endIndex = scrollerVm.endIndex;
    return index < startIndex || index > endIndex;
  }

  private isDeleteCollapsedMoreNtf(event: NotificationEvent): boolean {
    const ntf = event.notificationList[0];
    if (!ntf) {
      return false;
    }

    const isCollapsed = this.vmInjector.getNotificationMoreHeaderVm()?.isCollapsed ?? false;
    if (ntf.isMoreNtf() && isCollapsed) {
      return true;
    }
    return false;
  }

  public updateNtf(updateParam: IUpdateParam): void {
    this.updateList(updateParam);
    if (updateParam.ignoreNtfArr) {
      return;
    }
    this.updateStatusBar();
  }

  protected updateList(updateParam: IUpdateParam): void {
    log.showInfo(`updateList, updateType = ${updateParam.updateType}`);
    this.needCollapseUpdate = true;
    if (updateParam.updateType === UpdateType.COLLAPSE) {
      this.updateAllNtfWithoutSort();
      this.hideMoreNtfActionButtons();
    } else if (updateParam.updateType === UpdateType.DELETE_SINGLE) {
      this.handleLiveDeleteAccessibilityFocus(updateParam);
      this.deleteSingleNtfWithoutSort(updateParam);
    } else if (updateParam.updateType === UpdateType.DELETE_CHILD) {
      this.deleteChildNtfWithoutSort(updateParam);
    } else if (updateParam.updateType === UpdateType.DELETE_GROUP) {
      this.deleteGroupNtfWithoutSort(updateParam);
    } else if (updateParam.updateType === UpdateType.DELETE_BATCH) {
      this.deleteBatchNtfWithoutSort(updateParam);
    } else if (updateParam.updateType === UpdateType.DELETE_MORE_BRIEF) {
      this.separate(updateParam.ignoreNtfArr, true);
      this.sort(true);
    } else {
      this.needCollapseUpdate = false;
      this.separate(updateParam.ignoreNtfArr);
      this.sort();
      this.hideMoreNtfActionButtons();
      this.handleAddOrUpdateAccessibilityFocus(updateParam);
    }

    // 删除通知，隐藏通知设置弹框
    if (updateParam.updateType === UpdateType.DELETE_SINGLE || updateParam.updateType === UpdateType.DELETE_GROUP ||
      updateParam.updateType === UpdateType.DELETE_BATCH) {
      this.hideSettingDialog(updateParam);
    }

    if (this.vmInjector.getPanelVm()?.isVisible && !updateParam.ignoreTransform &&
      NEED_TRANSFORM_UPDATE_TYPE.has(updateParam.updateType)) {
      setTimeout(() => {
        this.vmInjector.getListScrollerVm()?.transform();
      }, 20)
    }
    log.showInfo(`mainNtfList length: ${this.mainNtfList.length}, moreNtfList length: ${this.moreNtfList.length}`);
  }

  protected updateStatusBar(): void {
    if (this.ntfCacheMap.size > 0) {
      // 存在缓存数据，需要结合缓存数据来发送状态栏图标，防止图标乱序
      this.postStatusBarEventDirectly();
    } else {
      this.postStatusBarEvent();
    }
  }

  protected saveNtf(incomingNtf: NotificationBase): NotificationBase | undefined {
    let result = super.saveNtf(incomingNtf);
    if (incomingNtf.isLiveView()) {
      LiveDropdownVmInjector.instance.updateVmByLive(incomingNtf, TAG);
    }
    return result;
  }

  protected clearNtf(incomingNtf: NotificationBase): NotificationBase | undefined {
    let result = super.clearNtf(incomingNtf);
    if (incomingNtf.isLiveView()) {
      LiveDropdownVmInjector.instance.deleteVmByLive(incomingNtf);
    }
    return result;
  }

  /**
   * 对通知进行分区
   */
  protected separate(ignoreNtfArr?: NotificationBase[], ignoreMainList: boolean = false): void {
    if (!ignoreMainList) {
      this.mainNtfList.clear();
    }
    this.moreNtfList.clear();

    const ignoreGroupKeyMap = new Map<string, boolean>();
    if (ignoreNtfArr) {
      ignoreNtfArr.forEach(ntf => ignoreGroupKeyMap.set(ntf.groupKey, true));
    }

    this.groupForEach((ntf) => {
      // 更新当前通知的vm
      this.updateVmByNtf(ntf);

      if (this.isNeedFilter(ntf, ignoreGroupKeyMap)) {
        return;
      }

      if (ntf.isMoreNtf()) {
        this.moreNtfList.push(ntf);
      } else if (!ignoreMainList) {
        this.mainNtfList.push(ntf);
      }
    });
  }

  /**
   * 刷新通知的vm
   */
  private updateVmByNtf(ntf: NotificationBase):void {
    // 更新当前通知的vm
    if (this.vmInjector.getCardVm(ntf).ntf !== ntf) {
      log.showWarn(`updateVmByNtf ntf hashCode: ${ntf.hashCode} groupKey: ${ntf.groupKey}`);
      this.vmInjector.updateVmByNtf(ntf);
    }

    // 若为组通知，还需更新子通知的vm
    if (ntf instanceof NormalNotificationGroup) {
      ntf.children.forEach((child) => {
        this.updateVmByNtf(child);
      });
    }
  }

  /**
   * 对通知列表进行排序
   */
  protected sort(ignoreMainList?: boolean): void {
    if (!ignoreMainList) {
      this.mainNtfList.sort();
    }
    this.moreNtfList.sort();
  }

  /**
   * 是否需要过滤
   * @param ntf 通知内容
   * @param ignoreGroupKeyMap 需要忽略的通知groupKey集合
   * @returns 是：需要过滤 否：不需要过滤
   */
  protected isNeedFilter(ntf: NotificationBase, ignoreGroupKeyMap?: Map<string, boolean>): boolean {
    // 云端模式下过滤白名单应用通知和实况
    if (!this.outdoorVm.isInOutdoorAppList(ntf)) {
      return true;
    }
    //应急模式下仅展示实况或白名单应用
    if (DeviceInfoVm.instance.isEmergencyMode() &&
      (!ntf.isLiveView() && !this.deviceInfoVm.emergencyModelTrustAppList.includes(ntf.creatorBundleName))) {
      return true;
    }

    if (ignoreGroupKeyMap?.has(ntf.groupKey)) {
      return true;
    }

    return false;
  }

  getMaxIndex(): number {
    if (this.moreNtfList.length === 0) {
      return Math.max(this.mainNtfList.length - 1);
    } else if (this.vmInjector.getNotificationMoreHeaderVm()?.isCollapsed) {
      return this.mainNtfList.length + 1;
    } else {
      return this.mainNtfList.length + this.moreNtfList.length;
    }
  }

  getItemId(ntf: NotificationBase): string {
    return this.vmInjector.getId(`${TAG}_Item_${ntf?.hashCode}`);
  }

  /**
   * 监听面板收起状态，收起时对于只有1条子通知的组通知需要解除组通知，组通知需要重置左滑和收起
   */
  @Monitor('isPanelVisible')
  onPanelVisibleChange(): void {
    if (this.isPanelVisible) {
      this.needCollapseUpdate = false;
      return;
    }
    this.groupForEach((ntf) => {
      this.updateGroup(ntf);
      this.vmInjector.getCardVm(ntf)?.reset();
    });
    if (this.needCollapseUpdate) {
      this.updateNtf({ updateType: UpdateType.ADD_OR_UPDATE });
      this.needCollapseUpdate = false;
    }
    NotificationSwipeVm.reset(undefined, false);
    NotificationNormalVm.hideActionButtons(this.vmInjector.scene);
    // 重置卡片滚动堆叠状态
    this.vmInjector.getListScrollerVm()?.transform(undefined, undefined, true);
  }

  @Monitor('deviceInfoVm.deviceMode', 'deviceInfoVm.emergencyModelTrustAppList')
  async onDeviceModeChange(monitor: IMonitor): Promise<void> {
    const deviceModeBefore = monitor.value('deviceInfoVm.deviceMode')?.before as DeviceModeEnum;
    const deviceModeNow = monitor.value('deviceInfoVm.deviceMode')?.now as DeviceModeEnum;
    log.showInfo(`deviceModeChange before: ${deviceModeBefore} after: ${deviceModeNow}`);

    if (deviceModeBefore !== deviceModeNow && deviceModeNow !== DeviceModeEnum.BASE_MODE) {
      // 切换到紧急模式仅显示白名单通知，先等面板收起后再刷新列表。
      await SystemUICommonUtil.sleep(DEVICE_MODE_CHANGE_NTF_DELAY);
    }

    this.updateNtf({ updateType: UpdateType.DEVICE_MODE_CHANGE });
  }

  @Monitor('outdoorVm.isInOutdoorMode', 'outdoorVm.outdoorAppList')
  onOutdoorModeChange(): void {
    log.showInfo(`onOutdoorModeChange: ${this.outdoorVm.isInOutdoorMode}`);
    this.updateNtf({ updateType: UpdateType.DEVICE_MODE_CHANGE });
  }

  /**
   * 发送状态栏图标显示事件
   */
  private postStatusBarEvent(): void {
    // 将通知的hashcode添加到列表
    const statusBarNtfList: NotificationBase[] = [];
    this.addStatusBarIconList(this.mainNtfList, statusBarNtfList);
    this.addStatusBarIconList(this.moreNtfList, statusBarNtfList);

    log.showInfo(`postStatusBarEvent, all ntf list size ${statusBarNtfList.length}`);
    NotificationStatusBarEventManager.get().postStatusBarNotificationEvent(statusBarNtfList);
  }


  /**
   * 发送状态栏图标显示事件
   * 使用临时数组来计算待显示的状态栏图标：需要懒更新的通知未在groupForEach里，因此需要先将缓存中的数据放入临时列表中
   */
  private postStatusBarEventDirectly(): void {
    let mainNtfList: NotificationArray = new NotificationArray();
    let moreNtfList: NotificationArray = new NotificationArray();

    this.ntfCacheMap.forEach((ntf) => {
      if (this.isNeedFilter(ntf)) {
        return;
      }
      if (ntf.isMoreNtf()) {
        moreNtfList.push(ntf);
      } else {
        mainNtfList.push(ntf);
      }
    });

    this.groupForEach((ntf) => {
      if (this.isNeedFilter(ntf)) {
        return;
      }
      if (ntf.isMoreNtf()) {
        moreNtfList.push(ntf);
      } else {
        mainNtfList.push(ntf);
      }
    });

    // 排序
    mainNtfList.sort();
    moreNtfList.sort();

    // 将通知的hashcode添加到列表
    const statusBarNtfList: NotificationBase[] = [];
    this.addStatusBarIconList(mainNtfList, statusBarNtfList);
    this.addStatusBarIconList(moreNtfList, statusBarNtfList);

    log.showInfo(`postStatusBarEventDirectly, all ntf list size ${statusBarNtfList.length}`);
    NotificationStatusBarEventManager.get().postStatusBarNotificationEvent(statusBarNtfList);
  }

  /**
   * 判断是否不将通知的图标放入待显示列表
   * @param item
   * @returns
   */
  protected isNotAddIcon(item: NotificationBase): boolean {
    const mapKey = item.creatorBundleName + item.creatorUid + item.isLiveView();
    return !mapKey || !item.isShowStatusBarIcon;
  }

  /**
   * 记录状态栏待显示通知的hashcode
   * @param ntfList
   * @param allNtfList
   */
  private addStatusBarIconList(ntfList: NotificationArray, allNtfList: NotificationBase[]) {
    const hashAddedMap: Record<string, boolean> = {};

    const addIcon = (item: NotificationBase) => {
      const mapKey = item.creatorBundleName + item.creatorUid + item.isLiveView();
      if (this.isNotAddIcon(item) || hashAddedMap[mapKey]) {
        return;
      }

      allNtfList.push(item);
      hashAddedMap[mapKey] = true;
    }

    ntfList.forEach(ntf => {
      // 组通知，遍历children
      if (ntf?.isNormalGroup()) {
        ntf.children?.forEach(ntfChild => {
          addIcon(ntfChild);
        });
        return;
      }

      // 单个通知
      addIcon(ntf);
    })
  }

  /**
   * 获取列表裁剪绘制指令
   * @param ntfList
   * @param allNtfList
   */
  private portraitGetClipShapeCommands(r: number, width: number, height: number, overWidth: number): string {
    let clipHeight = -height;
    if (DISABLE_HEAD_BLUR_EFFECT) {
      // 状态栏高度 + 2倍下沉高度
      clipHeight = ArkUIAdapter.vp2px(ResUtils.getNumber($r('app.float.status_bar_phone_height')) +
        NotificationStyle.DROPDOWN_STATUS_BAR_HEIGHT * 2);
    }
    return this.getClipShapePath(r, width, height, overWidth, clipHeight);
  }

  protected getClipShapeCommands(r: number, width: number, height: number, overWidth: number): string {
    return this.vmInjector.getPanelVm().isLandscapeLayout ?
    this.landscapeGetClipShapeCommands(r, width, height, overWidth) :
    this.portraitGetClipShapeCommands(r, width, height, overWidth);
  }

  protected getClipShapePath(r: number, width: number, height: number, overWidth: number, clipHeight: number): string {
    return `
      M0 ${clipHeight}
      L${width} ${clipHeight}
      L${width + overWidth} ${clipHeight}
      L${width + overWidth} ${height - r}
      L${width} ${height - r}
      A${r} ${r} 0 0 1 ${width - r} ${height}
      L${r} ${height}
      A${r} ${r} 0 0 1 0 ${height - r}
      L-${overWidth} ${height - r}
      L-${overWidth} ${clipHeight}
      L0 ${clipHeight}
      Z`;
  }

  /**
   * 更新对应组通知
   * @param ntf
   */
  public updateGroup(ntf: NotificationBase): void {
    if (!ntf.isNormalGroup()) {
      return;
    }
    if (ntf.children.length !== 1) {
      this.vmInjector.getNormalGroupVm(ntf)?.collapseGroup();
      return;
    }
    this.releaseGroup(ntf);
  }

  /**
   * 列表item尺寸变化
   */
  public onListItemSizeChange(): void {
    // 字体缩放等导致item尺寸变化，结束后更新列表滚动条堆叠状态。使用debounce避免过程中连续触发。
    this.vmInjector.getListScrollerVm()?.debouncedTransform();
  }

  /**
   * 判断是否是成组场景
   * @param event NotificationEvent
   */
  private getIsSaveGroupNtf(event: NotificationEvent): boolean {
    const ntf = event.notificationList[0];
    if (!ntf) {
      return false;
    }
    const existNtf = this.getNtfByGroupKey(ntf.groupKey);
    if (existNtf && !existNtf.isNormalGroup() && existNtf.isNormal() && ntf.isNormal()) {
      return true;
    }
    return false;
  }

  /**
   * 成组场景禁用过渡
   * @param event NotificationEvent
   * @param isFinish boolean
   */
  private disableSaveGroupTransition(event: NotificationEvent, isFinish = false): void {
    const ntf = event.notificationList[0];
    if (!ntf) {
      return;
    }
    const existGroupNtf = this.getNtfByGroupKey(ntf.groupKey);
    if (existGroupNtf) {
      this.vmInjector.getCardVm(existGroupNtf).isSaveGroupNtf = !isFinish;
    }
  }

  /**
   * 删除单通知，不触发排序更新列表
   * @param param IUpdateParam
   */
  private deleteSingleNtfWithoutSort(param: IUpdateParam) {
    this.mainNtfList.remove(param.updateNtfList?.[0].hashCode);
    this.moreNtfList.remove(param.updateNtfList?.[0].hashCode);
  }

  /**
   * 删除组通知内的子通知，不触发排序更新列表
   * @param param IUpdateParam
   */
  private deleteChildNtfWithoutSort(param: IUpdateParam) {
    if (param.updateNtfList) {
      const isMore = param.updateNtfList[0].isMoreNtf();
      const group = (isMore ? this.moreNtfList : this.mainNtfList).find((ntf) => {
        return ntf.groupKey === param.updateNtfList?.[0].groupKey;
      });
      if (group && group.isNormalGroup() && group.children.length === 1) {
        // 删除组通知内的最后一条子通知
        this.mainNtfList.remove(param.updateNtfList[0].groupKey);
        this.moreNtfList.remove(param.updateNtfList[0].groupKey);
      } else {
        // 删除组通知内的非最后一条子通知
        this.updateSingleNtfWithoutSort(param.updateNtfList[0]);
      }
    }
  }

  /**
   * 删除组通知，不触发排序更新列表
   * @param param IUpdateParam
   */
  private deleteGroupNtfWithoutSort(param: IUpdateParam) {
    const groupKey: string | undefined = param.updateNtfList?.[0].groupKey;
    this.mainNtfList.remove(groupKey);
    this.moreNtfList.remove(groupKey);
  }

  private deleteBatchNtfWithoutSort(param: IUpdateParam) {
    param.updateNtfList?.forEach((deleteNtf) => {
      log.showInfo(`deleteNtf: ${deleteNtf.hashCode}`)
      this.deleteSingleNtfWithoutSort({ updateType: UpdateType.DELETE_SINGLE, updateNtfList: [deleteNtf] });
      this.deleteChildNtfWithoutSort({ updateType: UpdateType.DELETE_CHILD, updateNtfList: [deleteNtf] });
    })
  }

  /**
   * 全量更新列表数据
   */
  private updateAllNtfWithoutSort(): void {
    this.mainNtfList.forEach((ntf, index) => {
      const group = this.getNtfByGroupKey(ntf.groupKey);
      if (group) {
        this.mainNtfList[index] = group;
      }
    });
    this.moreNtfList.forEach((ntf, index) => {
      const group = this.getNtfByGroupKey(ntf.groupKey);
      if (group) {
        this.moreNtfList[index] = group;
      }
    });
  }

  /**
   * 更新一条通知的数据
   * @param ntf NotificationBase 需要更新的通知数据
   */
  private updateSingleNtfWithoutSort(ntf: NotificationBase): void {
    const isMoreNtf: boolean = ntf.isMoreNtf();
    const targetList = isMoreNtf ? this.moreNtfList : this.mainNtfList;
    const index: number = targetList.findIndex((entry) => {
      return entry.groupKey === ntf.groupKey;
    });
    if (index === -1) {
      return;
    }

    const group = this.getNtfByGroupKey(ntf.groupKey);
    if (!group) {
      // 通知组已不存在
      targetList.splice(index, 1);
      return;
    }

    const groupVm = this.vmInjector.getNormalGroupVm(group);
    if (group.isNormalGroup() && group.children.length === 1 && groupVm && !groupVm.isExpanded) {
      // 折叠态，且只剩最后一条子通知，此时需要释放组通知
      targetList[index] = group.children[0];
      this.releaseGroup(group);
    } else {
      targetList[index] = group;
    }
  }

  /**
   * 解除组通知
   * @param group 组通知数据
   */
  releaseGroup(group: NormalNotificationGroup): void {
    if (group && group.children.length === 1) {
      log.showInfo('reset only child cardVm');
      // 重置cardVm
      this.vmInjector.getCardVm(group.children[0]).reset();
    }
    super.releaseGroup(group);
  }

  /**
   * 是否是正在展开折叠的第一个更多通知
   * @param index
   */
  public getIsFirstMoreNtfChanging(index: number): boolean {
    const isExtraNtfsCollapseStatusChanging = this.vmInjector.getMoreVm()?.isExtraNtfsCollapseStatusChanging;
    if (index === 0 && isExtraNtfsCollapseStatusChanging) {
      return true;
    }
    return false;
  }

  /**
   * 是否允许横滑面板切换双中心
   *
   * @param panelDownWindowY 触摸点Y
   * @param panelDownWindowX 触摸点X
   * @returns
   */
  public isAllowPanHorizontal(panelDownWindowY: number, panelDownWindowX: number): boolean {
    // 判断点击的是否为更多通知标题区域
    if (this.isInMoreHeaderArea(panelDownWindowY)) {
      return true;
    }
    // 判断是否点击的第一张卡片
    if (this.isInFirstItemWithLowOpacityArea(panelDownWindowY)) {
      return true;
    }
    return this.isInAllowSwitchArea(panelDownWindowY, panelDownWindowX);
  }

  private isInMoreHeaderArea(panelDownWindowY: number): boolean {
    if (this.moreNtfList.length === 0 || !this.moreNtfList[0]) {
      return false;
    }
    const rectInfo = ItemUtils.getRectById(this.vmInjector.getId(`NotificationListView_MoreHeader`));
    return panelDownWindowY <= rectInfo.bottom && panelDownWindowY >= rectInfo.top;
  }

  private isInFirstItemWithLowOpacityArea(panelDownWindowY: number): boolean {
    const startIndex = this.vmInjector.getListScrollerVm()?.startIndex;
    if (startIndex === undefined) {
      return false;
    }
    let ntf = this.getListItemByIndex(startIndex);
    if (!ntf) {
      return false;
    }
    if (this.vmInjector.getCardVm(ntf).opacity >= SWITCH_MIN_OPACITY) {
      // 透明度大于等于0.8时，不允许滑动
      return false;
    }
    // 查询后一张卡片的顶部位置
    ntf = this.getListItemByIndex(startIndex + 1);
    if (!ntf) {
      return false;
    }
    return panelDownWindowY < ItemUtils.getRectById(this.getItemId(ntf)).top;
  }

  private isInAllowSwitchArea(panelDownWindowY: number, panelDownWindowX: number): boolean {
    const listScrollerVm = this.vmInjector.getListScrollerVm();
    if (!listScrollerVm) {
      return true;
    }
    for (let i = listScrollerVm.endIndex; i >= listScrollerVm.startIndex; i--) {
      const ntf = this.getListItemByIndex(i);
      if (!ntf) {
        continue;
      }
      // 如果通知卡片的透明度小于0.8，则允许左滑切到控制中心
      if (this.vmInjector.getCardVm(ntf).opacity >= SWITCH_MIN_OPACITY) {
        return !this.isInNtfVisibleList(panelDownWindowY, panelDownWindowX, i);
      }
    }
    return true;
  }

  private hideMoreNtfActionButtons(): void {
    if (!this.vmInjector.getNotificationMoreHeaderVm()?.isCollapsed || !this.moreNtfList.length) {
      return;
    }
    const buttonHashCode = NotificationNormalVm.expandActionButtonMap.get(this.vmInjector.scene);
    if (!buttonHashCode) {
      return;
    }
    if (this.getNtfByHashCode(buttonHashCode)?.isMoreNtf()) {
      NotificationNormalVm.hideActionButtons(this.vmInjector.scene);
    }
  }

  private hideSettingDialog(param: IUpdateParam): void {
    if (!this.vmInjector.getSettingDiagVm()?.settingDiagData?.isShowDialog || !param.updateNtfList) {
      return;
    }
    const showSettingNtf = this.vmInjector.getSettingDiagVm()?.ntf;
    if (!showSettingNtf) {
      return;
    }
    if (param.updateNtfList.findIndex(item => item?.groupKey === showSettingNtf?.groupKey) >= 0) {
      this.vmInjector.getSettingDiagVm()?.hide();
    }
  }

  public isLandscapeLayoutChange = (isLandscapeLayout: boolean): void => {
    if (isLandscapeLayout) {
      this.layoutWeight = 0;
      this.emptyTextHeight = '100%';
      this.alignRules = {
        top: { anchor: '__container__', align: VerticalAlign.Top },
        start: { anchor: this.vmInjector.getId('NotificationHeaderView'), align: HorizontalAlign.End }
      };
      this.transparentCardHeight = 1;
    } else {
      this.layoutWeight = 1;
      this.emptyTextHeight = 'auto';
      this.alignRules = {
        top: { anchor: '__container__', align: VerticalAlign.Top },
        middle: { anchor: '__container__', align: HorizontalAlign.Center }
      };
      this.transparentCardHeight = TRANSPARENT_CARD_HEIGHT;
    }
  }

  @Computed
  get landscapeMargin(): Margin {
    return {
      left: 0,
      right: 0,
      bottom: this.isEmpty ? 0 : $r('app.float.ntf_list_land_item_padding_bottom'),
      top: this.isEmpty ? 0 : $r('app.float.ntf_land_title_padding_top'),
    };
  }

  /**
   * 根据屏幕宽度及屏幕状态计算内容宽度
   * 1、直板机、折叠屏折叠态横屏状态下取值采用栅格方式计算5/8栅格宽度
   * @returns 通知列表宽度
   */
  @Computed
  get landscapeWidth(): string {
    return '62.5%';
  }

  private landscapeGetClipShapeCommands(r: number, width: number, height: number, overWidth: number): string {
    let clipHeight = -height;
    if (DISABLE_HEAD_BLUR_EFFECT) {
      clipHeight = ArkUIAdapter.vp2px(ResUtils.getNumber($r('app.float.status_bar_phone_height')));
    }
    return this.getClipShapePath(r, width, height, overWidth, clipHeight);
  }

  public isGroupExpandingChange = (isGroupExpanding: boolean): void => {
    this.isGroupExpanding = isGroupExpanding;
    log.showInfo(`isGroupExpanding changed ${this.isGroupExpanding}`);
  }

  /**
   * 刷新缓存数据
   */
  flushCacheMap(dropDownEvent: DropDownEvent): void {
    // 仅通知中心下拉或控制中心切通知中心时若有数据才进行更新
    if (dropDownEvent.target === TargetPanel.NOTIFICATION_PANEL && this.ntfCacheMap.size > 0) {
      log.showInfo(`flushCacheMap count: ${this.ntfCacheMap.size}`);
      super.handleAddUpdateEvent(Array.from(this.ntfCacheMap.values()));
      this.ntfCacheMap.clear();
      this.updateNtf({
        updateType: UpdateType.ADD_OR_UPDATE,
        // 更新数据时不执行transform, 根据情况进行控制
        ignoreTransform: true
      });
      // 控制中心到通知中心才需要执行transform
      if (DropdownVm.instance.isFromCCToNC) {
        this.vmInjector.getListScrollerVm()?.transform();
      }
    }
  }

  /**
   * 该通知是否需要缓存
   * @param ntf 通知数据
   */
  private isNeedCache(ntf: NotificationBase): boolean {
    // 通知面板显示时不需要
    if (this.isPanelVisible) {
      return false;
    }

    // 本次是否为更新通知, 更新通知进行懒加载
    if (this.isUpdateEvent) {
      const existNtf = this.getNtfByHashCode(ntf.hashCode);
      // 同一哈希, 但属于不同组, 不缓存
      // 如下载模板通知由实况转为普通通知时groupKey将不一致
      return ntf.groupKey === existNtf?.groupKey;
    }

    return false;
  }

  /**
   * 通知列表添加或更新数据
   * @param incomingNtfList 添加/更新集
   */
  protected handleAddUpdateEvent(incomingNtfList: NotificationBase[]): void {
    let needDealList: NotificationBase[] = [];
    incomingNtfList?.forEach((incomingNtf) => {
      if (this.isNeedCache(incomingNtf)) {
        this.ntfCacheMap.set(incomingNtf.hashCode, incomingNtf);
      } else {
        this.ntfCacheMap.delete(incomingNtf.hashCode);
        needDealList.push(incomingNtf);
      }
    });

    if (needDealList.length > 0) {
      super.handleAddUpdateEvent(needDealList);
    } else {
      this.isNeedUpdate = false;
    }
  }

  /**
   * 通知列表删除数据
   * @param incomingNtfList 删除集
   */
  protected handleRemoveEvent(incomingNtfList: NotificationBase[]): void {
    incomingNtfList?.forEach((incomingNtf) => {
      this.ntfCacheMap.delete(incomingNtf.hashCode);
    });
    super.handleRemoveEvent(incomingNtfList);
  }

  /**
   * 新增、更新通知实况主动聚焦
   * @param updateParam
   */
  private handleAddOrUpdateAccessibilityFocus(updateParam: IUpdateParam): void {
    if (!AccessibilityVm.instance.isEnabled) {
      return;
    }
    if (updateParam.updateType !== UpdateType.ADD_OR_UPDATE || updateParam.updateNtfList?.length !== 1) {
      return;
    }
    const ntf: NotificationBase = updateParam.updateNtfList[0];
    const groupNtf: NormalNotificationGroup | undefined = this.getGroupNtf(ntf);
    const focusNtf = groupNtf && !this.vmInjector.getNormalGroupVm(groupNtf)?.isExpanded ? groupNtf : ntf;
    const compId: string = this.vmInjector.getCardVm(focusNtf).getAccessibilityFocusId();
    AccessibilityVm.instance.requestFocusAccessibility(compId, true);
  }

  /**
   * 删除实况主动聚焦适配，后续迁移
   * @param updateParam
   */
  private handleLiveDeleteAccessibilityFocus(updateParam: IUpdateParam): void {
    if (!AccessibilityVm.instance.isEnabled) {
      return;
    }
    if (updateParam.updateType !== UpdateType.DELETE_SINGLE || updateParam.updateNtfList?.length !== 1) {
      return;
    }
    const live: NotificationBase = updateParam.updateNtfList[0];
    if (!(live instanceof LiveNotification)) {
      return;
    }
    AccessibilityVm.instance.requestFocusAccessibility(this.vmInjector.getSwipeVm(live)?.getRemoveAccessibilityId(live) ?? '', true);
  }

  private startUpdateNtfListReport(eventType: number, isPanelDismissing: boolean) {
    if (eventType === NotificationEvent.EVENT_TYPE_REMOVE && !isPanelDismissing) {
      performanceMonitor.begin('CLEAR_NT_ANI', performanceMonitor.ActionType.LAST_UP, 'cancel');
    }
  }

  private endUpdateNtfListReport(eventType: number, isPanelDismissing: boolean) {
    if (eventType === NotificationEvent.EVENT_TYPE_REMOVE && !isPanelDismissing) {
      performanceMonitor.end('CLEAR_NT_ANI');
    }
  }
}