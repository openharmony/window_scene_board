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
import { GestureState, SysDialogParamsKey, SysDialogZOrder } from '../common/Constants';
import { DialogDataEvent, ISystemDialogData, IParameters } from '../common/DialogDataEvent';
import { SystemDialogEventUtil, SystemDialogState } from '../common/SysDialogEventUtil';
import { BusinessError } from '@kit.BasicServicesKit';
import { CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { SCBScreenSessionManager } from '@ohos/windowscene';

const TAG = 'CFWKDialog-Controller';
const GT_KEY = TAG + 'CFWKSystemDialogController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
const DATA_SUCCESS_CODE = 0;
const DATA_ERROR_CODE = 1;

export class SystemDialogController {
  private data: Map<string, ISystemDialogData> = new Map();
  private defaultList: Array<ISystemDialogData> = [];
  private upperList: Array<ISystemDialogData> = [];
  private context: common.ServiceExtensionContext | null = null;
  private sysDialogStatus: boolean = false;
  // 多屏下弹窗与screenId的映射
  private statusMapScreen: Map<number, boolean> = new Map([
    [0, false],
  ]);

  setStatusByScreenId(screenId: number, status: boolean): void {
    log.showInfo(`setStatusByScreenId ${screenId} ${status}`);
    this.statusMapScreen.set(screenId, status);
  }

  getStatusByScreenId(screenId: number): boolean {
    const status = this.statusMapScreen.get(screenId);
    log.showInfo(`getStatusByScreenId ${screenId} ${status}`);
    return status || false;
  }

  setSysDialogStatus(status: boolean): void {
    log.showInfo(`setSysDialogStatus ${status}`);
    this.sysDialogStatus = status;
  }

  getSysDialogStatus(): boolean {
    return this.sysDialogStatus;
  }

  getSysDialogEvent(): DialogDataEvent {
    return this.dataEvent;
  }
  /**
   * 弹框数据刷新事件
   */
  private dataEvent: DialogDataEvent = new DialogDataEvent();

  showPreloadWindow(connectId: string): void {
    log.showInfo(`showPreloadWindow start`);
    let sysDialogZOrder = this.getSysDialogZOrder(connectId);
    this.sendDataEvent(sysDialogZOrder === SysDialogZOrder.DEFAULT ? this.defaultList : this.upperList,
      sysDialogZOrder, connectId, 6);
  }

  sendDataEvent(dialogDatas: Array<ISystemDialogData>, sysDialogZOrder: SysDialogZOrder,
    connectId: string, flag: number): void {
    try {
      const targetList = dialogDatas.length !== 0 ? dialogDatas.filter(o => o.connectId === connectId) : [];
      if (targetList && targetList.length !== 0) {
        const item = targetList[0];
        item.count = (item?.count || 0) + 1;
        item.flag = flag;
        this.setDataEvent(sysDialogZOrder, dialogDatas, item);
      } else {
        this.setDataEvent(SysDialogZOrder.DEFAULT, [], undefined);
        log.showInfo(`send data event no preload dialog`);
      }
    } catch (err) {
      log.showInfo(`send data event error ${err}`);
    }
  }

  loadPreloadWindow(connectId: string): void {
    log.showInfo(`loadPreloadWindow start`);
    let sysDialogZOrder = this.getSysDialogZOrder(connectId);
    this.sendDataEvent(sysDialogZOrder === SysDialogZOrder.DEFAULT ? this.defaultList : this.upperList,
      sysDialogZOrder, connectId, 7);
  }

  /**
   * 更新UI
   */
  private setDataEvent(sysDialogZOrder: SysDialogZOrder, list: Array<ISystemDialogData>,
    item?: ISystemDialogData): void {
    log.showInfo(`setDataEvent start`);
    this.dataEvent.dialogZOrder = sysDialogZOrder;
    this.dataEvent.dataList = [...list];
    this.dataEvent.defaultList = [...this.defaultList];
    this.dataEvent.upperList = [...this.upperList];
    if (item) {
      this.dataEvent.item = item;
      this.dataEvent.count = item.count || 0;
      this.dataEvent.flag = item.flag || 0;
    }
    AppStorage.setOrCreate('cfwkSysDialogEvent', this.dataEvent);
    log.showInfo(`setDataEvent end`);
  }

  static getInstance(): SystemDialogController {
    let instance = Reflect.get(globalThis, GT_KEY) as SystemDialogController;
    if (instance === null || instance === undefined) {
      instance = new SystemDialogController();
      Reflect.set(globalThis, GT_KEY, instance)
    }
    return instance;
  }

  setContext(context: common.ServiceExtensionContext): void {
    this.context = context;
    log.showInfo('setContext end');
  }

  getContext(): common.ServiceExtensionContext {
    return this.context as common.ServiceExtensionContext;
  }

  getList(zOrder: SysDialogZOrder): Array<ISystemDialogData> {
    log.showInfo(`getList start ${zOrder}`);
    if (zOrder === SysDialogZOrder.DEFAULT) {
      return this.defaultList;
    }

    return this.upperList;
  }

  isAllListEmpty(): boolean {
    const empty = this.defaultList.length === 0 && this.upperList.length === 0;
    log.showInfo(`isAllListEmpty ${empty}`);
    if (this.defaultList.length) {
      const list = this.defaultList?.map(item => {
        return `${item?.id} ${item?.want?.abilityName}`;
      });
      log.showWarn(`isAllListEmpty ${empty} ${list?.toString()}`);
    }
    return empty;
  }

  getData(): Map<string, ISystemDialogData> {
    return this.data;
  }

  addDataByKey(key: string, v: ISystemDialogData): void {
    log.showInfo(`${key} addDataByKey start`);
    const sysDialogZOrder = v.sysDialogZOrder;
    const needPush = sysDialogZOrder === SysDialogZOrder.DEFAULT || sysDialogZOrder === SysDialogZOrder.UPPER;
    const oldSysDialogZOrder = this.data.get(key)?.sysDialogZOrder;

    this.data.set(key, v);

    if (!needPush) {
      log.showWarn(`${key} addDataByKey no-push`);
      return;
    }

    if (typeof oldSysDialogZOrder === 'number') {
      log.showInfo(`${key} addDataByKey findAndRemoveFromLists`);
      this.findAndRemoveFromLists(key, oldSysDialogZOrder);
    }

    log.showInfo(`${key} addDataByKey before default:${this.defaultList.length} upper:${this.upperList.length}`);

    const list = this.getList(sysDialogZOrder);
    list.push(v);

    // 数据刷新，更新UI
    this.setDataEvent(sysDialogZOrder, list, v);

    log.showInfo(`${key} addDataByKey end ${sysDialogZOrder} len:${this.defaultList.length} ${this.upperList.length}`);
    SystemDialogEventUtil.reportSystemDialogEvent(SystemDialogEventUtil.EVENT_NAME,
      v, SystemDialogState.OPEN);
  }

  removeDataByKey(key: string): number {
    log.showInfo(`${key} removeDataByKey start`);

    const item = this.data.get(key);
    if (!item) {
      log.showError(`${key} removeDataByKey: data is null`);
      return DATA_ERROR_CODE;
    }
    const sysDialogZOrder = item.sysDialogZOrder!;
    this.findAndRemoveFromLists(key, sysDialogZOrder);
    this.data.delete(key);

    log.showInfo(`${key} removeDataByKey end`);
    SystemDialogEventUtil.reportSystemDialogEvent(SystemDialogEventUtil.EVENT_NAME,
      item, SystemDialogState.CLOSE);
    return DATA_SUCCESS_CODE;
  }

  private getSysDialogZOrder(connectId: string): number {
    const item = this.data.get(connectId);
    if (!item || !item.sysDialogZOrder) {
      log.showError(`${connectId} data is null`);
      return DATA_ERROR_CODE;
    }
    return item.sysDialogZOrder;
  }

  findAndRemoveFromLists(key: string, sysDialogZOrder: SysDialogZOrder): void {
    const list = this.getList(sysDialogZOrder);
    log.showInfo(`${key} findAndRemoveFromLists start ${sysDialogZOrder} length ${list.length}`);

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
      log.showError(`${connectId} closeByConnectId end by index<0`);
      return;
    }
    const list = this.getList(sysDialogZOrder);
    log.showInfo(`${connectId} closeByConnectId before ${this.getListConnectId(list)}`);

    if (list.length === 0) {
      log.showError(`${connectId} closeByConnectId end by list.length=0`);
      return;
    }
    const index = list.findIndex(item => {
      if (abilityName) {
        return item.connectId === connectId && item.want.abilityName === abilityName;
      } else {
        return item.connectId === connectId;
      }
    });
    log.showInfo(`${connectId} closeByConnectId index ${index} ${abilityName}`);
    if (index === -1) {
      return;
    }
    const item = (list.splice(index, 1))[0];
    log.showInfo(`${connectId} closeByConnectId after ${this.getListConnectId(list)}`);
    this.unlockRotationForPowerOff(item);

    // 数据删除，更新UI
    this.setDataEvent(sysDialogZOrder, list, item);

    if (needClear) {
      this.data.delete(item.id);
    }
    log.showInfo(`${connectId} closeByConnectId end list length ${list.length}`);
    SystemDialogEventUtil.reportSystemDialogEvent(SystemDialogEventUtil.EVENT_NAME,
      item, SystemDialogState.CLOSE);
  }

  unlockRotationForPowerOff(item: ISystemDialogData): void {
    const abilityName = item?.want?.abilityName;
    if (abilityName === 'PoweroffAbility') {
      const screenSession = SCBScreenSessionManager.getInstance()?.getMainScreenSession();
      if (CommonUtils.isInvalid(screenSession)) {
        log.showInfo(`unlock power off page rotation failed`);
        return;
      }
      log.showInfo(`unlock powe roff start`);
      screenSession?.setEnableRotate(true, 'poweroff');
      log.showInfo(`unlock power off end`);
      screenSession?.rotationChangeEntry(screenSession.sensorScreenProperty.rotation, 'unlock power off page rotation');
      log.showInfo('unlock power off page rotation');
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
      const targetKey = Reflect.get(want?.parameters as IParameters, key) as number
      if (targetKey === target) {
        log.showInfo(`filter ${key} bundleName:${want?.bundleName} abilityName:${want?.abilityName}`);
        return true;
      }
      return false;
    });
    return filterList;
  }

  closeAll(): void {
    log.showInfo('closeAll start');
    const clearList = (list: ISystemDialogData[], sysDialogZOrder: SysDialogZOrder): void => {
      for (let index = list.length - 1; index >= 0; index--) {
        this.closeByConnectId(list[index]?.connectId, sysDialogZOrder);
      }
    };
    clearList(this.defaultList, SysDialogZOrder.DEFAULT);
    clearList(this.upperList, SysDialogZOrder.UPPER);
    Reflect.set(globalThis, GT_KEY, null);
    log.showWarn(`closeAll end ${this.defaultList.length} ${this.upperList.length}`);
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
      log.showInfo(`clearAll isExistDisableUpGestureDialog ${isExistDisableUpGestureDialog}`);
      if (!isExistDisableUpGestureDialog) {
        this.closeAll();
        this.destroy();
        log.showInfo(`clearAll end`);
      } else {
        const disableList = data.map(item => `${item.want.bundleName}:${item.want.abilityName}`).toString();
        log.showWarn(`clearAll stop ${disableList}`);
      }
    } catch (error) {
      log.showError(`clearAll error ${error}`);
    }
  }

  destroy(): void {
    log.showInfo('clear start');
    this.data?.clear();
    this.context?.terminateSelf((error: BusinessError) => {
      if (error.code) {
        log.showError(`terminateSelf failed, error.code: ${error.code}, error.message: ${error.message}`);
        return;
      }
      log.showWarn('terminateSelf in file:Controller>destroy');
    });
    this.context = null;
    log.showInfo('clear end');
  }
}

export default SystemDialogController;
