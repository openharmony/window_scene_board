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

import { NotificationGlassVm, NotificationUtil } from './NotificationGlassVm';
import Ntf from '@ohos.notificationSubscribe';
import { NotificationGlassVmArray } from './NotificationVmItemArray';
import { GlassNtfManager, NtfChangeCallBack } from '../../bannerpanel/manager/GlassNtfManager';
import { NotificationEntry } from '@ohos/notificationcomponent/src/main/ets/model/NotificationEntry';
import { BusinessError, systemDateTime } from '@kit.BasicServicesKit';
import { ArrayUtils, LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';

const TAG: string = 'Ntf-GlassNtfListVm';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.VISION_GLASS, TAG);
const NEED_SORT_NUM_LIMIT: number = 2;
const NEED_SWAP: number = -1;
const NO_NEED_SWAP: number = 1;
const ONE_CHILD_NTF = 1;
const DEFAULT_SPLICE_NUM: number = 1;

enum ArrIndex {
  NOT_FIND = -1,
  FIRST_ITEM = 0
};

/**
 * 通知列表数据处理
 */
export class GlassNtfListVm {
  /*
   * 单例
   * */
  private static instance: GlassNtfListVm | null = null;
  /*
   * 单通知hashcode表
   * */
  private ntfHashcodeMap: Map<string, NotificationGlassVm> = new Map();
  /*
   * 组通知表
   * */
  private ntfGroupMap: Map<string, NotificationGlassVm> = new Map();
  /*
   * 全量通知表 用于查验当前同组通知以及判断当前通知是否为空
   * */
  private allNtfList: NotificationGlassVm[] = [];
  /*
   * 更新状态栏通知icon红点提示回调
   * */
  private updateRedHotCallback?: (isShowRedHot: boolean) => void;
  /*
   * 更新通知中心消息列表实例
   * */
  private ntfCenterComponent?: NOTIFICATION_CENTER;

  /*
   * 注册更新状态栏红点状态回调
   *
   * @param callback 红点提示回调
   * */
  public registerRedHotCallback(callback: ((isShowRedHot: boolean) => void)): void {
    log.showInfo(`registerRedHotCallback`);
    this.updateRedHotCallback = callback;
  }

  /*
   * 注册更新通知中心消息列表回调
   *
   * @param component 通知中心组件实例
   * */
  public registerNtfCenterComponent(component: NOTIFICATION_CENTER): void {
    log.showInfo(`registerNtfCenterComponent`);
    this.ntfCenterComponent = component;
  }

  private updateMessageRedHot(): void {
    if (this.updateRedHotCallback) {
      log.showInfo(`updateMessageRedHot,current ntfGroupList length is ${this.ntfCenterComponent?.ntfGroupList?.length}`);
      this.updateRedHotCallback(this.ntfCenterComponent?.ntfGroupList?.length !== 0);
    }
  }

  /**
   * 初始化
   */
  public init(): void {
    log.showInfo('init');
    // 注册消息接收者
    GlassNtfManager.getInstance().registerNtfChangeCallBack(this.ntfChangeCallBack);
    GlassNtfManager.getInstance().checkAndGetCallNtf();
  }

  /**
   * 消息组排序
   */
  public sortNftGroupItem(): void {
    if (this.ntfCenterComponent === undefined) {
      return;
    }
    log.showInfo(`sortNftGroupItem,ntfGroupList length is ${this.ntfCenterComponent.ntfGroupList.length}`);
    if (this.ntfCenterComponent.ntfGroupList.length >= NEED_SORT_NUM_LIMIT) {
      this.ntfCenterComponent.ntfGroupList.sort((entryA, entryB): number => {
        if (entryA.isDisplayAtTop || entryB.isDisplayAtTop) {
          if (entryA.isDisplayAtTop !== entryB.isDisplayAtTop) {
            return entryA.isDisplayAtTop ? NEED_SWAP : NO_NEED_SWAP;
          }
        }
        return entryB.deliveryTime - entryA.deliveryTime;
      });
    }
    let callIndex: number =
      this.ntfCenterComponent.ntfGroupList.findIndex((ntf) => NotificationUtil.checkIsCallNtf(ntf));
    if (callIndex !== ArrIndex.NOT_FIND) {
      let callNtfs: NotificationGlassVm[] = this.ntfCenterComponent.ntfGroupList.splice(callIndex, DEFAULT_SPLICE_NUM);
      this.ntfCenterComponent.ntfGroupList.unshift(...callNtfs);
    } else {
      log.showInfo(`sortNftGroupItem callNtf cancel,not exist`);
    }
  }

  constructor() {
    log.showInfo(`constructor`);
  }

  /**
   * 清空类字段
   */
  public release(): void {
    this.ntfCenterComponent = undefined;
    this.ntfHashcodeMap.clear();
    this.allNtfList = [];
    this.ntfGroupMap.clear();
    this.updateRedHotCallback = undefined;
  }

  /*
   * 获取单例
   * */
  public static getInstance(): GlassNtfListVm {
    if (!GlassNtfListVm.instance) {
      log.showInfo(`getInstance new instance`);
      GlassNtfListVm.instance = new GlassNtfListVm();
    }
    return GlassNtfListVm.instance;
  }

  /*
   * 销毁类单例
   * */
  public static destroyInstance(): void {
    log.showInfo('destroyInstance');
    GlassNtfListVm.instance?.release();
    GlassNtfListVm.instance = null;
  }

  /**
   * 眼镜删除消息
   *
   * @param itemGroup 待删除消息组
   */
  public clearByGlass(item: NotificationGlassVm): void {
    log.showInfo(`clearByGlass hash: ${item.hashCode}, reason: ${item.reason}`);
    try {
      Ntf.remove(item.hashCode, Ntf.RemoveReason.CANCEL_REASON_REMOVE)
        .then(() => {
          log.showInfo('clearByGlass success');
        })
        .catch((err: BusinessError) => {
          log.showError(`clearByGlass fail ,error is ${JSON.stringify(err)}`);
        })
    } catch (err) {
      log.showError(`clearByGlass fail2,error is ${err.code}`);
    }
  }

  /**
   * 根据itemGroup清除缓存中的数据(组消息删除、手机端直接清除相关应用消息)
   *
   * @param itemGroup 待删除消息组
   */
  public clearByItemGroup(itemGroup?: NotificationGlassVm): void {
    if (!itemGroup) {
      log.warn('itemGroup is empty');
      return;
    }
    let groupKey = itemGroup.creatorBundleName;
    let group: NotificationGlassVm | undefined = this.ntfGroupMap.get(groupKey);
    let hashCodes: string[] = [];
    if (group) {
      group?.childrenArr.forEach((item: NotificationGlassVm) => {
        hashCodes.push(item.hashCode);
      })
    } else {
      hashCodes.push(itemGroup.hashCode);
    }
    try {
      Ntf.remove(hashCodes, Ntf.RemoveReason.CANCEL_REASON_REMOVE)
        .then(() => {
          log.showInfo(`clearByItemGroup success,ntfGroupList num:${this.ntfCenterComponent?.ntfGroupList.length}`);
        })
        .catch((err: BusinessError) => {
          log.showError(`clearByItemGroup ${itemGroup.creatorBundleName} fail,err code is ${err.code}`);
        })
    } catch (err) {
      log.showError(`clearByItemGroup ${itemGroup.creatorBundleName}  fail2,err code is ${err.code}`);
    }
  }

  /**
   * 清除所有通知
   */
  public clearAllNtf(): void {
    // 无可清除通知
    if (ArrayUtils.isEmpty(this.allNtfList)) {
      log.showInfo('clearAllNtf no ntf');
      return;
    }
    let removeHashcodeList: string[] = [];
    this.allNtfList.forEach((item: NotificationGlassVm) => {
      if (!NotificationUtil.checkIsCallNtf(item)) {
        removeHashcodeList.push(item.hashCode);
      }
    })
    try {
      Ntf.remove(removeHashcodeList, Ntf.RemoveReason.CANCEL_REASON_REMOVE)
        .then(() => {
          log.showInfo(`clearAllNtf success`);
        })
        .catch((err: BusinessError) => {
          log.showError(`clearAllNtf fail,errCode is ${err.code}`);
        })
    } catch (err) {
      log.showError(`clearAllNtf fail2,errCode is ${err.code}`);
    }
  }

  private ntfChangeCallBack: NtfChangeCallBack = {
    addNtf: (phoneNtfs: NotificationEntry[]) => {
      phoneNtfs.forEach((phoneNtf: NotificationEntry) => {
        this.handleAddNtf(phoneNtf);
      });
      this.sortNftGroupItem();
      this.updateMessageRedHot();
    },

    updateNtf: (phoneNtfs: NotificationEntry[]) => {
      phoneNtfs.forEach((phoneNtf: NotificationEntry) => {
        this.handleUpdateNtf(phoneNtf);
        this.sortNftGroupItem();
        this.updateMessageRedHot();
      });
    },

    removeNtf: (ntfs: NotificationEntry[]) => {
      ntfs.forEach((ntf: NotificationEntry) => {
        this.handleNtfRemove(ntf);
      });
      this.sortNftGroupItem();
      this.updateMessageRedHot();
    }
  };

  private handleUpdateNtf(phoneNtf: NotificationEntry | NotificationGlassVm): void {
    let ntf = new NotificationGlassVm();
    ntf.updateDataFromPhone(phoneNtf);
    log.showInfo(`handleUpdateNtf: ntf is ${ntf.toSimpleString()}`);
    if (!NotificationUtil.isNtfAsRequired(ntf)) {
      if (!ntf.deliveryTime) {
        ntf.deliveryTime = systemDateTime.getTime();
      }
    }
    let isNtfExist: boolean = this.ntfHashcodeMap.has(ntf.hashCode);
    if (!isNtfExist) {
      log.showInfo(`handleUpdateNtf,current ntf is not exist,change to handle add`);
      this.handleAddNtf(ntf);
      return;
    }
    this.updateItem(this.allNtfList, ntf);
    this.ntfHashcodeMap.set(ntf.hashCode, ntf);
    log.showInfo(`handleUpdateNtf,allNtfList num is ${(this.allNtfList.length)},ntfHashcodeMap num is ${this.ntfHashcodeMap.size}`);
    let groupKey = ntf.creatorBundleName;
    let oldGroup: undefined | NotificationGlassVm = this.ntfGroupMap.get(groupKey);
    if (oldGroup) { // 存在分组
      this.updateItem(oldGroup.childrenArr, ntf);
      log.showInfo(`handleUpdateNtf,oldGroup is exist,child is updated and num is ${oldGroup.getChildrenSize()}`);
      oldGroup.sortChildren();
      this.updateUINtf(ntf);
    } else { //不存在分组 直接更新UI单通知
      log.showInfo(`handleUpdateNtf,oldGroup is not exist,ntfCenterComponent is exist ${!!this.ntfCenterComponent}`);
      this.updateUINtf(ntf);
    }
  }

  private handleAddNtf(phoneNtf: NotificationEntry | NotificationGlassVm) {
    let ntf = new NotificationGlassVm();
    ntf.updateDataFromPhone(phoneNtf);
    let isNtfExist: boolean = this.ntfHashcodeMap.has(ntf.hashCode);
    if (isNtfExist) {
      log.showInfo(`handleAddNtf,current ntf ${ntf.hashCode} already exist,change to handle update`);
      this.handleUpdateNtf(ntf)
      return;
    }
    log.showInfo(`handleAddNtf start addNtfItem: ${ntf.toSimpleString()}`);
    if (!NotificationUtil.isNtfAsRequired(ntf)) {
      if (!ntf.deliveryTime) {
        ntf.deliveryTime = systemDateTime.getTime();
      }
    }
    this.ntfHashcodeMap.set(ntf.hashCode, ntf);
    this.allNtfList.push(ntf);
    log.showInfo(`handleAddNtf allNtfList num is ${this.allNtfList.length},ntfHashcodeMap num is ${this.ntfHashcodeMap.size}`);
    let ntfGroup: undefined | NotificationGlassVm = this.ntfGroupMap.get(ntf.creatorBundleName);
    if (ntfGroup === undefined) { // 不存在分组 需要判断是否创建分组
      log.showInfo(`handleAddNtf,group ${ntf.hashCode} not exist group`);
      let childs: NotificationGlassVm[] =
        this.allNtfList.filter(ntfItem => ntfItem.creatorBundleName === ntf.creatorBundleName);
      const isNeedCreateGroup: number = 1;
      if (childs.length > isNeedCreateGroup) { //子通知数量大于1，需要创建通知分组
        let group: NotificationGlassVm = new NotificationGlassVm();
        group.updateDataFromPhone(childs[ArrIndex.FIRST_ITEM]);
        group.isGroup = true;
        group.childrenArr.push(...childs);
        group.sortChildren();
        this.ntfGroupMap.set(ntf.creatorBundleName, group);
        log.showInfo(`handleAddNtf,group ${ntf.creatorBundleName} created, child num is ${group.childrenArr.length}`);
        // 更新 UI数据 单通知 -> 组通知
        this.transformNtfGroupStatus(group);
      } else { // 子通知数量小于1，不需要创建分组
        this.addUISingleNtf(ntf);
        log.showInfo(`handleAddNtf,ntfGroupList add single ntf,ntfGroupList length is ${this.ntfCenterComponent?.ntfGroupList.length}`);
      }
    } else { //存在分组 不需要创建
      ntfGroup.childrenArr.push(ntf);
      ntfGroup.sortChildren();
      log.showInfo(`handleAddNtf,group ${ntf.hashCode} already exist group,child num is ${ntfGroup.getChildrenSize()}`);
      // Ui数据新增子通知 组通知 -> 组通知
      this.addUISingleNtf(ntf, ntf.creatorBundleName);
    }
    log.showInfo(`handleAddNtf,ntfGroupList:${this.ntfCenterComponent?.ntfGroupList.length}`);
  }

  /**
   * 通知列表删除数据
   *
   * @param ntfList 删除集
   */
  private handleNtfRemove(item: NotificationGlassVm | NotificationEntry): void {
    log.showInfo(`handleNtfRemove hash: ${item.hashCode}, reason: ${item.reason}`);
    let isExist: boolean = this.ntfHashcodeMap.has(item.hashCode);
    if (!isExist) {
      log.showError(`handleNtfRemove hash:${item.hashCode} is not exist`);
      return;
    }
    this.allNtfList = this.allNtfList.filter((ntfListItem) => ntfListItem.hashCode !== item.hashCode);
    this.ntfHashcodeMap.delete(item.hashCode);
    log.showInfo(`handleNtfRemove allNtfList:${this.allNtfList.length},ntfHashcodeMap num is ${this.ntfHashcodeMap.size}`);
    let group: NotificationGlassVm | undefined = this.ntfGroupMap.get(item.creatorBundleName);
    if (group) { // 存在分组通知
      log.showInfo(`handleNtfRemove,group ${group.creatorBundleName} is exist`);
      if (group.removeChild(item)) { // 删除成功
        if (group.getChildrenSize() <= ONE_CHILD_NTF) { // 剩余最后一个子通知，变为单通知
          log.showInfo(`group ${item.creatorBundleName} changed to single ntf`);
          this.ntfGroupMap.delete(item.creatorBundleName);
          group.updateDataFromPhone(group.childrenArr[ArrIndex.FIRST_ITEM]);
          group.isGroup = false;
          this.transformNtfGroupStatus(group);
        } else {
          this.deleteUINtf(item, item.creatorBundleName); // 更新UI数据
        }
      } else {
        log.showWarn('remove item failed');
      }
    } else { // 不存在分组通知 直接清除UI数据中的单通知
      log.showInfo(`handleNtfRemove hashcode ${item.hashCode} is removed from ntfGroupList`);
      this.deleteUINtf(item);
    }
  }

  private updateItem(ntfs: NotificationGlassVm[], ntfItem: NotificationGlassVm | NotificationEntry): void {
    for (const ntf of ntfs) {
      if (ntf.hashCode === ntfItem.hashCode && ntf.creatorBundleName === ntfItem.creatorBundleName) {
        log.showInfo(`updateItem hashcode ${ntfItem.hashCode}`);
        ntf.deliveryTime = ntfItem.deliveryTime;
        ntf.notificationContent = ntfItem.notificationContent;
        ntf.actionButtons = ntfItem.actionButtons;
        ntf.appIcon = ntfItem.appIcon;
        ntf.isFromSystemApp = ntfItem.isFromSystemApp;
        ntf.smallIcon = ntfItem.smallIcon;
        ntf.wantAgent = ntfItem.wantAgent;
        ntf.wantAgentInfo = ntfItem.wantAgentInfo;
        ntf.liveViewData = ntfItem.liveViewData;
        ntf.isGroup = ntfItem.isGroup;
      }
    }
  }

  private transformNtfGroupStatus(ntf: NotificationGlassVm): void {
    if (!this.ntfCenterComponent) {
      log.showInfo(`transformNtfGroupStatus,ntfCenterComponent is not exist`);
      return;
    }
    let oldItem: NotificationGlassVm | undefined =
      this.ntfCenterComponent.ntfGroupList.find(item => item.creatorBundleName === ntf.creatorBundleName);
    if (oldItem) {
      log.showInfo(`transformNtfGroupStatus ntf ${oldItem.creatorBundleName} is transformed from ${oldItem.isGroup} to ${ntf.isGroup},child num is ${ntf.getChildrenSize()}`);
      oldItem.updateDataFromPhone(ntf);
      oldItem.isGroup = ntf.isGroup;
      this.updateChildArr(oldItem.childrenArr, ntf.childrenArr);
      oldItem.sortChildren();
    } else {
      log.showInfo(`transformNtfGroupStatus,ntf ${ntf.hashCode} is not exist`);
    }
  }

  private updateChildArr(oldList: NotificationGlassVmArray, newList: NotificationGlassVmArray) {
    log.showInfo(`updateChildArr oldList num is ${oldList.length},newList num is ${newList.length}`);
    let addList: NotificationGlassVm[] = [];
    let deleteList: NotificationGlassVm[] = [];
    oldList.forEach(oldItem => {
      if (newList.findIndex(newItem => newItem.hashCode === oldItem.hashCode) === ArrIndex.NOT_FIND) {
        deleteList.push(oldItem);
      }
    })
    newList.forEach(newItem => {
      if (oldList.findIndex(oldItem => oldItem.hashCode === newItem.hashCode) === ArrIndex.NOT_FIND) {
        addList.push(newItem);
      }
    })
    const NO_CHILD: number = 0;
    if (addList.length > NO_CHILD) {
      log.showInfo(`updateChildArr,add child num is ${addList.length}`);
      oldList.push(...addList);
    } else if (deleteList.length > NO_CHILD) {
      log.showInfo(`updateChildArr,delete child num is ${deleteList.length}`);
      deleteList.forEach((deleteItem, index: number) => {
        let deleteIndex: number = oldList.findIndex(oldItem => oldItem.hashCode === deleteItem.hashCode);
        oldList.splice(deleteIndex, DEFAULT_SPLICE_NUM);
      })
    } else {
      log.showWarn(`updateChildArr cancel,no need to update`);
    }
  }

  private addUISingleNtf(ntf: NotificationGlassVm, groupKey?: string): void {
    if (!this.ntfCenterComponent) {
      log.showInfo(`addUISingleNtf,ntfCenterComponent is not exist`);
      return;
    }
    if (groupKey) { //传入组名key值代表当前通知存在分组，需要检查并以分组子通知形式新增至UI
      let group: NotificationGlassVm | undefined =
        this.ntfCenterComponent.ntfGroupList.find(item => item.creatorBundleName === groupKey);
      if (group) {
        group.childrenArr.push(ntf);
        group.sortChildren();
        log.showInfo(`group ${groupKey} child add and num is ${group.getChildrenSize()}`);
        return;
      } else {
        log.showInfo(`group ${groupKey} not exist in ntfGroupList`);
      }
    } //未传入组名Key值或key值未找到相对应组通知，则按照单通知新增
    this.ntfCenterComponent.ntfGroupList.push(ntf);
  }

  private deleteUINtf(ntf: NotificationGlassVm | NotificationEntry, groupKey?: string): void {
    if (!this.ntfCenterComponent) {
      log.showInfo(`deleteUINtf,ntfCenterComponent is not exist`);
      return;
    }
    if (groupKey) {
      let group: NotificationGlassVm | undefined =
        this.ntfCenterComponent.ntfGroupList.find(item => item.creatorBundleName === groupKey);
      if (group) {
        let deleteIndex: number = group.childrenArr.findIndex(groupItem => groupItem.hashCode === ntf.hashCode);
        if (deleteIndex !== ArrIndex.NOT_FIND) {
          group.childrenArr.splice(deleteIndex, DEFAULT_SPLICE_NUM);
          return;
        } else {
          log.showWarn(`deleteUINtf,ntf ${ntf.hashCode} is not exist in group ${groupKey}`);
        }
      } else {
        log.showWarn(`deleteUINtf,group ${groupKey} is not exist in ntfGroupList`);
      }
    }
    let deleteIndex: number = this.ntfCenterComponent.ntfGroupList.findIndex(item => item.hashCode === ntf.hashCode);
    this.ntfCenterComponent.ntfGroupList.splice(deleteIndex, 1);
  }

  /*
   * 更新: 单通知 ---> 单通知|子通知 ---> 子通知
   * */
  private updateUINtf(ntf: NotificationGlassVm): void {
    if (!this.ntfCenterComponent) {
      log.showInfo(`updateUINtf,ntfCenterComponent is not exist`);
      return;
    }
    let group: NotificationGlassVm | undefined =
      this.ntfCenterComponent.ntfGroupList.find(item => item.creatorBundleName === ntf.creatorBundleName);
    if (group) { //当前存在分组 子通知 ---> 子通知
      this.updateItem(group.childrenArr, ntf);
    } else { //当前不存在分组 单通知 ---> 单通知
      this.updateItem(this.ntfCenterComponent.ntfGroupList, ntf);
    }
  }
}

interface NOTIFICATION_CENTER {
  ntfGroupList: NotificationGlassVmArray
}

