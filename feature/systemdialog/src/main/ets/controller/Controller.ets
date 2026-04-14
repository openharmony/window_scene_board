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

import { common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { EvtBus } from '@ohos/frameworkwrapper';
import { CommonUtils, LogDomain, Logger } from '@ohos/basicutils';
import { GestureState, SysDialogParamsKey, SysDialogZOrder, FocusState } from '../common/Constants';
import { DialogDataEvent, IParameters, ISystemDialogData } from '../common/DialogDataEvent';
import { SystemDialogEventUtil, SystemDialogState } from '../common/SysDialogEventUtil';
import { SCBScreenSessionManager } from '@ohos/windowscene';

const TAG = 'Dialog-ServiceExtensionAbility2';
const GT_KEY = TAG + 'SystemDialogController';
const log: Logger = Logger.getLogHelper(LogDomain.SYS_UI);
const DATA_SUCCESS_CODE = 0;
const DATA_ERROR_CODE = 1;

class SystemDialogController {
  private count: number = 0;
  private data: Map<string, ISystemDialogData> = new Map();
  private defaultList: Array<ISystemDialogData> = [];
  private upperList: Array<ISystemDialogData> = [];
  private context: common.ServiceExtensionContext | null = null;
  private sysDialogStatus: boolean = false;
  // 多屏下弹窗与screenId的映射
  private statusMapScreen: Map<number, boolean> = new Map([
    [0, false],
  ]);
  private static _instance: SystemDialogController | undefined

  setStatusByScreenId(screenId: number, status: boolean): void {
    log.showInfo(TAG, `setStatusByScreenId ${screenId} ${status}`);
    this.statusMapScreen.set(screenId, status);
  }

  getStatusByScreenId(screenId: number): boolean {
    const status = this.statusMapScreen.get(screenId);
    log.showInfo(TAG, `getStatusByScreenId ${screenId} ${status}`);
    return status || false;
  }

  setSysDialogStatus(status: boolean): void {
    log.showInfo(TAG, `setSysDialogStatus ${status}`);
    this.sysDialogStatus = status;
  }

  getSysDialogStatus(): boolean {
    return this.sysDialogStatus;
  }
  /**
   * 弹框数据刷新事件
   */
  private dataEvent: DialogDataEvent = new DialogDataEvent();

  /**
   * 数据删除，更新UI
   */
  private setDataEvent(sysDialogZOrder: SysDialogZOrder, list: Array<ISystemDialogData>,
    item: ISystemDialogData): void {
    log.showInfo(TAG, `setDataEvent start`);
    this.dataEvent.dialogZOrder = sysDialogZOrder;
    this.dataEvent.dataList = [...list];
    this.dataEvent.defaultList = [...this.defaultList];
    this.dataEvent.upperList = [...this.upperList];
    this.dataEvent.item = item;
    EvtBus.post(DialogDataEvent, this.dataEvent);
    log.showInfo(TAG, `setDataEvent end`);
  }

  static getInstance(): SystemDialogController {
    if (SystemDialogController._instance === null || SystemDialogController._instance === undefined) {
      SystemDialogController._instance = new SystemDialogController();
    }
    return SystemDialogController._instance;
  }

  setContext(context: common.ServiceExtensionContext): void {
    this.context = context;
    log.showInfo(TAG, 'setContext end');
  }

  getContext(): common.ServiceExtensionContext {
    return this.context as common.ServiceExtensionContext;
  }

  getList(zOrder: SysDialogZOrder): Array<ISystemDialogData> {
    log.showInfo(TAG, `getList start ${zOrder}`);
    if (zOrder === SysDialogZOrder.DEFAULT) {
      return this.defaultList;
    }

    return this.upperList;
  }

  isAllListEmpty(): boolean {
    const empty = this.defaultList.length === 0 && this.upperList.length === 0;
    log.showInfo(TAG, `isAllListEmpty ${empty}`);
    if (this.defaultList.length) {
      const list = this.defaultList?.map(item => {
        return `${item?.id} ${item?.want?.abilityName}`;
      });
      log.showWarn(TAG, `isAllListEmpty ${empty} ${list?.toString()}`);
    }
    return empty;
  }

  getData(): Map<string, ISystemDialogData> {
    return this.data;
  }

  addDataByKey(key: string, v: ISystemDialogData): void {
    log.showInfo(TAG, `${key} addDataByKey start`);
    const sysDialogZOrder = v.sysDialogZOrder;
    const needPush = sysDialogZOrder === SysDialogZOrder.DEFAULT || sysDialogZOrder === SysDialogZOrder.UPPER;
    const oldSysDialogZOrder = this.data.get(key)?.sysDialogZOrder;

    this.data.set(key, v);

    if (!needPush) {
      log.showWarn(TAG, `${key} addDataByKey no-push`);
      return;
    }

    if (typeof oldSysDialogZOrder === 'number') {
      log.showInfo(TAG, `${key} addDataByKey findAndRemoveFromLists`);
      this.findAndRemoveFromLists(key, oldSysDialogZOrder);
    }

    log.showInfo(TAG, `${key} addDataByKey before default:${this.defaultList.length} upper:${this.upperList.length}`);

    const list = this.getList(sysDialogZOrder);
    list.push(v);

    // 数据刷新，更新UI
    this.setDataEvent(sysDialogZOrder, list, v);

    log.showInfo(TAG, `${key} addDataByKey end ${sysDialogZOrder} len:${this.defaultList.length} ${this.upperList.length}`);
    SystemDialogEventUtil.reportSystemDialogEvent(SystemDialogEventUtil.EVENT_NAME,
      v, SystemDialogState.OPEN);
    // 弹窗获焦模式打点，后续打点需要整改
    const focusState = v.want?.parameters?.focusState;
    if (focusState === FocusState.DISABLE || focusState === FocusState.ENABLE) {
      SystemDialogEventUtil.reportSystemDialogEvent(SystemDialogEventUtil.EVENT_NAME, v,
        focusState === FocusState.DISABLE ? SystemDialogState.DISABLE_FOCUS : SystemDialogState.ENABLE_FOCUS);
    }
  }

  removeDataByKey(key: string): number {
    log.showInfo(TAG, `${key} removeDataByKey start`);

    const item = this.data.get(key);
    if (!item) {
      log.showError(TAG, `${key} removeDataByKey: data is null`);
      return DATA_ERROR_CODE;
    }
    const sysDialogZOrder = item.sysDialogZOrder!;
    this.findAndRemoveFromLists(key, sysDialogZOrder);
    this.data.delete(key);

    log.showInfo(TAG, `${key} removeDataByKey end`);
    SystemDialogEventUtil.reportSystemDialogEvent(SystemDialogEventUtil.EVENT_NAME,
      item, SystemDialogState.CLOSE);
    return DATA_SUCCESS_CODE;
  }

  findAndRemoveFromLists(key: string, sysDialogZOrder: SysDialogZOrder): void {
    const list = this.getList(sysDialogZOrder);
    log.showInfo(TAG, `${key} findAndRemoveFromLists start ${sysDialogZOrder} length ${list.length}`);

    this.closeByConnectId(key, sysDialogZOrder, false);
  }

  /**
   * 返回所有的连接id
   */
  getListConnectId(list: ISystemDialogData[]): string {
    return list?.map(o => o?.connectId).toString();
  }

  /**
   * 根据connectId关闭弹窗内容
   * @param connectId 连接id
   * @param sysDialogZOrder 弹窗层级
   * @param needClear 是否需要清除
   */
  closeByConnectId(
    connectId: string,
    sysDialogZOrder: SysDialogZOrder,
    needClear: boolean = true,
    abilityName: string = ''
  ): void {
    if (connectId.length < 0) {
      log.showError(TAG, `${connectId} closeByConnectId end by index<0`);
      return;
    }
    const list = this.getList(sysDialogZOrder);
    log.showInfo(TAG, `${connectId} closeByConnectId before ${this.getListConnectId(list)}`);

    if (list.length === 0) {
      log.showError(TAG, `${connectId} closeByConnectId end by list.length=0`);
      return;
    }
    const index = list.findIndex(item => {
      if (abilityName) {
        return item.connectId === connectId && item.want.abilityName === abilityName;
      } else {
        return item.connectId === connectId;
      }
    });
    log.showInfo(TAG, `${connectId} closeByConnectId index ${index} ${abilityName}`);
    if (index === -1) {
      return;
    }
    const item = (list.splice(index, 1))[0];
    log.showInfo(TAG, `${connectId} closeByConnectId after ${this.getListConnectId(list)}`);
    this.unlockRotationForPowerOff(item);

    // 数据删除，更新UI
    this.setDataEvent(sysDialogZOrder, list, item);

    if (needClear) {
      this.data.delete(item.id);
    }

    log.showInfo(TAG, `${connectId} closeByConnectId end list length ${list.length}`);
    SystemDialogEventUtil.reportSystemDialogEvent(SystemDialogEventUtil.EVENT_NAME,
      item, SystemDialogState.CLOSE);
  }

  unlockRotationForPowerOff(item: ISystemDialogData): void {
    const abilityName = item?.want?.abilityName;
    if (abilityName === 'PoweroffAbility') {
      const screenSession = SCBScreenSessionManager.getInstance()?.getMainScreenSession();
      if (CommonUtils.isInvalid(screenSession)) {
        log.showInfo(TAG, `unlock power off page rotation failed`);
        return;
      }
      log.showInfo(TAG, `unlock powe roff start`);
      screenSession?.setEnableRotate(true, 'poweroff');
      log.showInfo(TAG, `unlock power off end`);
      screenSession?.rotationChangeEntry(screenSession.sensorScreenProperty.rotation, 'unlock power off page rotation');
      log.showInfo(TAG, 'unlock power off page rotation');
    }
  }

  /**
   * 根据指定的key过滤
   * @param list 应用列表
   * @param key 过滤的key
   * @param target 目标值
   * @returns []
   */
  filterListByKey(list: ISystemDialogData[], key: string, target: number): ISystemDialogData[] {
    const filterList = list.filter((item: ISystemDialogData) => {
      const want = item.want;
      const targetKey = want?.parameters ? Reflect.get(want?.parameters as IParameters, key) as number : undefined
      if (targetKey === target) {
        log.showInfo(TAG, `filter ${key} bundleName:${want?.bundleName} abilityName:${want?.abilityName}`);
        return true;
      }
      return false;
    });
    return filterList;
  }

  closeAll(): void {
    log.showInfo(TAG, 'closeAll start');

    const clearList = (list: ISystemDialogData[], sysDialogZOrder: SysDialogZOrder): void => {
      for (let index = list.length - 1; index >= 0; index--) {
        this.closeByConnectId(list[index]?.connectId, sysDialogZOrder);
      }
    };

    clearList(this.defaultList, SysDialogZOrder.DEFAULT);
    clearList(this.upperList, SysDialogZOrder.UPPER);

    log.showWarn(TAG, `closeAll end ${this.defaultList.length} ${this.upperList.length}`);
  }

  requestDestroy(): void {
    if (this.isAllListEmpty()) {
      this.destroy();
    }
  }

  // 清理所有数据
  clearAll(): void {
    try {
      // 检查多弹窗中是否存在霸屏窗口
      const allList: ISystemDialogData[] = [...this.defaultList, ...this.upperList];
      const data = this.filterListByKey(allList, SysDialogParamsKey.disableUpGesture, GestureState.ENABLE);
      const isExistDisableUpGestureDialog = data?.length > 0;
      log.showInfo(TAG, `clearAll isExistDisableUpGestureDialog ${isExistDisableUpGestureDialog}`);
      if (!isExistDisableUpGestureDialog) {
        this.closeAll();
        this.destroy();
        log.showInfo(TAG, `clearAll end`);
      } else {
        const disableList = data.map(item => `${item.want.bundleName}:${item.want.abilityName}`).toString();
        log.showWarn(TAG, `clearAll stop ${disableList}`);
      }
    } catch (error) {
      log.showError(TAG, `clearAll error ${error}`);
    }
  }

  destroy(): void {
    log.showInfo(TAG, 'clear start');
    this.data?.clear();
    this.context?.terminateSelf((error: BusinessError) => {
      if (error.code) {
        log.showError(TAG, `terminateSelf failed, error.code: ${error.code}, error.message: ${error.message}`);
        return;
      }
      log.showWarn(TAG, 'terminateSelf in file:Controller>destroy');
    });
    this.context = null;
    log.showInfo(TAG, 'clear end');
  }
}

export default SystemDialogController;
