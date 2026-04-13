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
import { ArrayUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import {
  NotificationBaseVm,
  INotificationDataVm,
  NotificationRefreshType,
  NotificationRefreshRecord
} from '@ohos/systemuicommon/newIndex';
import {
  InnerEventUtil,
  LiveType,
  NormalNotification,
  NormalNotificationGroup,
  NotificationBase,
  NotificationCategory,
  NotificationEvent
} from '@ohos/systemuicommon/newTsIndex';

const TAG = 'NotificationDataVm';
const log = LogHelper.getLogHelper(LogDomain.NC, TAG);

// 数据刷新记录仪
interface InnerRecord extends NotificationRefreshRecord {
  // 是否开启数据记录
  isRecordEnable: boolean;
}

/**
 * 通知全数据处理业务
 */
export abstract class NotificationDataVm extends NotificationBaseVm implements INotificationDataVm {
  /**
   * 业务使用场景名
   */
  protected readonly vmName: string = 'default';
  /**
   * 所有通知数据集，分组key
   * <groupKey, NotificationBase>
   */
  private readonly ntfGroupMap: Map<string, NotificationBase> = new Map();
  /**
   * 所有通知数据集，hashcode key
   * <hashcode, NotificationBase>
   */
  private readonly ntfHashMap: Map<string, NotificationBase> = new Map();
  /**
   * 数据刷新记录仪
   */
  private readonly dataRefreshRecord: InnerRecord = {
    isRecordEnable: false,
    isDataRefresh: false,
    dataRefreshType: NotificationRefreshType.DATA_INIT,
    changeDataSet: new Set(),
    updateDataSet: new Set()
  };
  /**
   * 处理通知事件
   * @param event 事件
   */
  private onNotificationEvent = (event: NotificationEvent): void => {
    this.handleNotificationEvent(event);
  };

  /**
   * 初始化
   */
  init(): void {
    log.showInfo(`Init: ${this.vmName}`);
    InnerEventUtil.on(NotificationEvent, this.onNotificationEvent);
  }

  /**
   * 销毁
   */
  destroy(): void {
    log.showInfo(`Destroy: ${this.vmName}`);
    InnerEventUtil.off(NotificationEvent, this.onNotificationEvent);
    // 清空数据
    this.ntfGroupMap.clear();
    this.ntfHashMap.clear();
  }

  /**
   * 分组数据集遍历
   * @param callback 遍历回调
   */
  groupForEach(callback: (value: NotificationBase, key: string, map: Map<string, NotificationBase>) => void): void {
    this.ntfGroupMap.forEach(callback);
  }

  /**
   * 取值分组数据
   * @param groupKey 分组标识
   * @returns 分组数据
   */
  getNtfByGroupKey(groupKey: string): NotificationBase | undefined {
    return this.ntfGroupMap.get(groupKey);
  }

  /**
   * 取值单数据
   * @param hashcode 单通知标识
   * @returns 单数据
   */
  getNtfByHashCode(hashcode: string): NotificationBase | undefined {
    return this.ntfHashMap.get(hashcode);
  }

  /**
   * 取值组通知数据
   * @param ntf 原数据
   * @returns 组通知数据
   */
  getGroupNtf(ntf: NotificationBase): NormalNotificationGroup | undefined {
    const existNtf = this.ntfGroupMap.get(ntf?.groupKey);
    return existNtf?.isNormalGroup() ? existNtf : undefined;
  }

  /**
   * 解除组通知
   * @param group 组通知数据
   */
  releaseGroup(group: NormalNotificationGroup): void {
    log.showInfo(`Release group for ${group?.groupKey}`);
    if (group) {
      this.delMapData(group);
      this.saveNtf(group.children?.[0]);
      this.vmInjector.deleteVmByNtf(group);
    }
  }

  /**
   * 删除剩单条通知时，是否解除组通知
   * @returns true解除组通知
   */
  protected abstract isResetGroup(): boolean;

  /**
   * 数据刷新处理
   * @param dataRecord 数据刷新记录
   */
  protected onDataChange(dataRecord: NotificationRefreshRecord): void {
  }

  /**
   * 通知数据事件处理
   * 函数才能子类复写调用super
   * @param event 事件
   */
  protected handleNotificationEvent(event: NotificationEvent): void {
    log.showInfo(`handleNotificationEvent, type: ${event.eventType}, size: ${event.notificationList?.length}`);
    if (!event.notificationList?.length && event.eventType !== NotificationEvent.EVENT_TYPE_INIT) {
      return;
    }

    const ntfList = this.handleExcludeNtf(event.notificationList);

    // 开启数据刷新记录
    this.startRecordDataRefresh();
    if (event.eventType === NotificationEvent.EVENT_TYPE_INIT) {
      this.handleInitEvent(ntfList);
      // 标记初始化数据
      this.recordRefreshType(NotificationRefreshType.DATA_INIT);
    } else if (event.eventType === NotificationEvent.EVENT_TYPE_ADD) {
      this.handleAddUpdateEvent(ntfList);
      // 标记新增数据
      this.recordRefreshType(NotificationRefreshType.DATA_ADD);
    } else if (event.eventType === NotificationEvent.EVENT_TYPE_UPDATE) {
      this.handleAddUpdateEvent(ntfList);
      // 标记更新数据
      this.recordRefreshType(NotificationRefreshType.DATA_UPDATE);
    } else if (event.eventType === NotificationEvent.EVENT_TYPE_REMOVE) {
      this.handleRemoveEvent(ntfList);
      // 标记删除数据
      this.recordRefreshType(NotificationRefreshType.DATA_DELETE);
    }
    // 关闭数据刷新记录
    let recordResult = this.endRecordDataRefresh();
    // 数据刷新回调
    this.onDataChange(recordResult);
  }

  /**
   * 过滤不支持在通知面板显示的ntf
   * @param ntfList
   * @returns
   */
  protected handleExcludeNtf(ntfList: NotificationBase[]): NotificationBase[] {
    return ntfList.filter(ntf => {
      // 即时类实况不显示
      if (this.isExcludedNtf(ntf)) {
        return false;
      }

      return true;
    })
  }

  /**
   * 是否需要忽略不处理
   * @param ntf
   * @returns
   */
  protected isExcludedNtf(ntf: NotificationBase): boolean {
    // 即时类实况不显示
    return ntf.isLiveView() && (ntf.type === LiveType.INSTANT || ntf.type === LiveType.INSTANT_BANNER);
  }

  /**
   * 通知列表初始化
   * @param incomingNtfList 初始化通知列表
   */
  protected handleInitEvent(incomingNtfList: NotificationBase[]): void {
    this.ntfGroupMap.clear();
    this.ntfHashMap.clear();
    this.handleAddUpdateEvent(incomingNtfList);
  }

  /**
   * 通知列表添加或更新数据
   * @param incomingNtfList 添加/更新集
   */
  protected handleAddUpdateEvent(incomingNtfList: NotificationBase[]): void {
    incomingNtfList?.forEach((incomingNtf) => {
      this.deleteWrongGroup(incomingNtf);
      let newData = this.saveNtf(incomingNtf);
      // 记录新增数据
      if (newData) {
        this.recordDataArr(newData);
      }
    });
  }

  /**
   * 通知列表删除数据
   * @param incomingNtfList 删除集
   */
  protected handleRemoveEvent(incomingNtfList: NotificationBase[]): void {
    incomingNtfList?.forEach((incomingNtf) => {
      let delData = this.clearNtf(incomingNtf);
      // 记录删除数据
      if (delData) {
        this.recordDataArr(delData);
      }
    });
  }

  /**
   * 如果通知的分组信息变了，需要将其从原位置删除
   * @param incomingNtf 新来通知
   */
  protected deleteWrongGroup(incomingNtf: NotificationBase): void {
    const existNtf = this.ntfHashMap.get(incomingNtf?.hashCode);
    // 不存在相同ID的通知，无需关注分组信息
    if (!existNtf) {
      return;
    }
    // 非组通知，分组信息变化或紧急类型通知，则直接清除旧数据
    const existGroupNtf = this.getGroupNtf(existNtf);
    if (!existGroupNtf) {
      if (incomingNtf.groupKey !== existNtf.groupKey || incomingNtf.category === NotificationCategory.EMERGENCY) {
        log.showInfo(`deleteWrongGroup ${incomingNtf.groupKey}, ${incomingNtf.category}`);
        this.delMapData(existNtf);
        // 实况复用view、vm
        if (!existNtf.isLiveView()) {
          this.vmInjector.deleteVmByNtf(existNtf);
        }
      }
    } else {
      // 组通知，分组信息变化，则清除旧数据
      if (incomingNtf.groupKey === existNtf.groupKey) {
        return;
      }
      log.showInfo(`deleteWrongGroup from ${existNtf.groupKey} to ${incomingNtf.groupKey}`);
      this.delHashMapData(existNtf.hashCode);
      const newGroup = existGroupNtf.removeChild(existNtf.hashCode);
      // 删除数据后无法成组
      if (!newGroup) {
        this.delMapData(existGroupNtf);
        this.vmInjector.deleteVmByNtf(existNtf);
        this.vmInjector.deleteVmByNtf(existGroupNtf);
      } else if (newGroup.children.length === 1) {
        this.releaseGroup(newGroup);
      } else {
        this.addMapData(newGroup);
        this.vmInjector.updateVmByNtf(newGroup);
      }
    }
  }

  /**
   * 保存通知
   * @param incomingNtf 新来通知
   * @returns true新成组通知
   */
  protected saveNtf(incomingNtf: NotificationBase): NotificationBase | undefined {
    if (!incomingNtf) {
      return undefined;
    }
    let addData: NotificationBase | undefined = undefined;
    const existNtf = this.ntfGroupMap.get(incomingNtf.groupKey);
    log.showInfo(`Save ntf for ${incomingNtf.hashCode}, existNtf groupKey: ${incomingNtf.groupKey}`);

    if (existNtf) {
      // 已经有组通知，则将其加入到组通知
      if (existNtf?.isNormalGroup()) {
        log.showInfo(`Add ntf ${incomingNtf.hashCode} to group ${existNtf.groupKey}`);
        this.addHashMapData(incomingNtf);
        const group = existNtf.addOrUpdateChild(incomingNtf as NormalNotification);
        // 更新组通知的VM
        this.vmInjector.updateVmByNtf(group);
        this.addMapData(group);
        // 记录数据刷新
        this.recordUpdateDataArr(group);
        this.recordDataRefresh(true);
      } else if (existNtf.hashCode === incomingNtf.hashCode) {
        log.showInfo(`Update single ntf for ${incomingNtf.hashCode}`);
        // 两个通知hashCode一样，则替换它
        this.addHashMapData(incomingNtf);
        this.addMapData(incomingNtf);
        // 记录数据刷新
        this.recordUpdateDataArr(incomingNtf);
        this.recordDataRefresh(true);
      } else if (existNtf.isNormal() && incomingNtf.isNormal()) {
        log.showInfo(`Merge ntf ${existNtf.hashCode} and ${incomingNtf.hashCode} to group ${incomingNtf.groupKey}`);
        // 两个通知hashCode不一样但groupKey一样就组成一个组
        const group = new NormalNotificationGroup(existNtf, incomingNtf);
        group.updateKey(undefined, true);
        this.addHashMapData(incomingNtf);
        this.addMapData(group);
        // 记录数据刷新
        this.recordUpdateDataArr(group);
        this.recordDataRefresh(true);
        this.vmInjector.updateVmByNtf(group);
        // 这里还需要子通知的更新isInGroup
      }
    } else {
      // 新增单组通知
      this.addHashMapData(incomingNtf);
      this.addMapData(incomingNtf);
      addData = incomingNtf;
      // 记录数据刷新
      this.recordDataRefresh(true);
    }
    // 更新通知的VM
    this.vmInjector.updateVmByNtf(incomingNtf);
    return addData;
  }

  /**
   * 清除通知数据
   * @param incomingNtf 删除数据
   * @returns 被清除组通知
   */
  protected clearNtf(incomingNtf: NotificationBase): NotificationBase | undefined {
    if (!incomingNtf) {
      return undefined;
    }
    let clearData: NotificationBase | undefined = undefined;
    const existNtf = this.ntfGroupMap.get(incomingNtf.groupKey);
    log.showInfo(`Delete ntf ${incomingNtf.hashCode}, existNtf groupKey: ${incomingNtf.groupKey}`);
    if (existNtf?.isNormalGroup()) {
      this.delHashMapData(incomingNtf.hashCode);
      const newGroup = existNtf.removeChild(incomingNtf.hashCode);
      if (!newGroup) {
        log.showInfo(`Delete group ntf: ${incomingNtf.groupKey}`);
        // 组通知被清除
        clearData = existNtf;
        this.delMapData(existNtf);
        this.vmInjector.deleteVmByNtf(existNtf);
        // 记录数据刷新
        this.recordDataRefresh(true);
      } else if (newGroup.children.length === 1 && this.isResetGroup()) {
        // 只有一条通知且面板为收起状态则解除组通知
        this.releaseGroup(newGroup);
        // 记录数据刷新
        this.recordUpdateDataArr(newGroup);
        this.recordDataRefresh(true);
      } else {
        log.showInfo(`Update group ntf: ${newGroup.groupKey}`);
        this.addMapData(newGroup);
        this.vmInjector.updateVmByNtf(newGroup);
        // 记录数据刷新
        this.recordUpdateDataArr(newGroup);
        this.recordDataRefresh(true);
      }
    } else if (existNtf?.hashCode === incomingNtf.hashCode) {
      log.showInfo(`Delete single ntf: ${incomingNtf.hashCode}`);
      clearData = existNtf;
      this.delMapData(incomingNtf);
      // 记录数据刷新
      this.recordDataRefresh(true);
    }
    this.vmInjector.deleteVmByNtf(incomingNtf);
    return clearData;
  }

  /**
   * 开启数据刷新记录
   */
  private startRecordDataRefresh(): void {
    this.resetRecordDataRefresh();
    this.dataRefreshRecord.isRecordEnable = true;
  }

  /**
   * 结束数据刷新记录
   * @returns 最终记录结果
   */
  private endRecordDataRefresh(): NotificationRefreshRecord {
    if (this.dataRefreshRecord.isRecordEnable) {
      // 最终记录结果进行转换
      let changeSet: Set<string> = new Set();
      this.dataRefreshRecord.changeDataSet?.forEach((groupKey) => {
        changeSet.add(groupKey);
        // 新增/删除数据，按非更新处理
        this.dataRefreshRecord.updateDataSet?.delete(groupKey);
      });
      let updateSet: Set<string> = new Set();
      this.dataRefreshRecord.updateDataSet?.forEach((groupKey) => updateSet.add(groupKey));
      let result: NotificationRefreshRecord = {
        isDataRefresh: this.dataRefreshRecord.isDataRefresh,
        dataRefreshType: this.dataRefreshRecord.dataRefreshType,
        changeDataSet: changeSet,
        updateDataSet: updateSet
      };
      // 重置记录仪
      this.resetRecordDataRefresh();
      return result;
    }
    this.resetRecordDataRefresh();
    return { isDataRefresh: false, dataRefreshType: NotificationRefreshType.DATA_INIT };
  }

  /**
   * 数据刷新记录复位
   */
  private resetRecordDataRefresh(): void {
    this.dataRefreshRecord.isRecordEnable = false;
    this.dataRefreshRecord.isDataRefresh = false;
    this.dataRefreshRecord.dataRefreshType = NotificationRefreshType.DATA_INIT;
    this.dataRefreshRecord.changeDataSet?.clear();
    this.dataRefreshRecord.updateDataSet?.clear();
  }

  /**
   * 记录数据刷新状态
   * @param isRefresh true数据刷新
   */
  private recordDataRefresh(isRefresh: boolean): void {
    // 开启记录时，允许刷新状态
    if (this.dataRefreshRecord.isRecordEnable) {
      this.dataRefreshRecord.isDataRefresh = isRefresh;
    }
  }

  /**
   * 记录新增/删除数据
   * @param ntf 变化数据
   */
  private recordDataArr(ntf: NotificationBase): void {
    // 开启记录时，允许记录变化数据
    if (this.dataRefreshRecord.isRecordEnable) {
      this.dataRefreshRecord.changeDataSet?.add(ntf?.groupKey);
    }
  }

  /**
   * 记录更新数据
   * @param ntf 变化数据
   */
  private recordUpdateDataArr(ntf: NotificationBase): void {
    // 开启记录时，允许记录变化数据
    if (this.dataRefreshRecord.isRecordEnable) {
      this.dataRefreshRecord.updateDataSet?.add(ntf?.groupKey);
    }
  }

  /**
   * 记录数据刷新类型
   * @param refreshType 刷新类型
   */
  private recordRefreshType(refreshType: NotificationRefreshType): void {
    // 初始化场景，直接记录
    if (refreshType === NotificationRefreshType.DATA_INIT) {
      this.dataRefreshRecord.dataRefreshType = refreshType;
      return;
    }
    // 新增、更新场景，有数据则新增，无数据则更新
    if (refreshType === NotificationRefreshType.DATA_ADD || refreshType === NotificationRefreshType.DATA_UPDATE) {
      let resultType = ArrayUtils.isEmpty(this.dataRefreshRecord.changeDataSet) ?
      NotificationRefreshType.DATA_UPDATE : NotificationRefreshType.DATA_ADD;
      this.dataRefreshRecord.dataRefreshType = resultType;
      return;
    }
    // 删除场景，有数据则删除，无数据则更新
    let resultType = ArrayUtils.isEmpty(this.dataRefreshRecord.changeDataSet) ?
    NotificationRefreshType.DATA_UPDATE : NotificationRefreshType.DATA_DELETE;
    this.dataRefreshRecord.dataRefreshType = resultType;
  }

  /**
   * 缓存数据
   * @param group 数据
   */
  private addMapData(group: NotificationBase): void {
    if (group) {
      this.ntfGroupMap.set(group.groupKey, group);
    }
  }

  /**
   * 缓存hashcode标识数据
   * @param single 数据
   */
  protected addHashMapData(single: NotificationBase): void {
    if (single) {
      this.ntfHashMap.set(single.hashCode, single);
    }
  }

  /**
   * 清除已有数据
   * @param existNtf 已有数据
   * @returns true删除成功
   */
  private delMapData(existNtf: NotificationBase): boolean {
    if (!existNtf) {
      return false;
    }
    if (existNtf.isNormalGroup()) {
      existNtf.children?.forEach((child) => this.delHashMapData(child?.hashCode));
    } else {
      this.delHashMapData(existNtf.hashCode);
    }
    return this.ntfGroupMap.delete(existNtf.groupKey);
  }

  /**
   * 清除hashcode标识数据
   * @param hashcode 标识
   * @returns true删除成功
   */
  protected delHashMapData(hashcode: string): boolean {
    return this.ntfHashMap.delete(hashcode);
  }
}