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

import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { DeviceHelper, RdbStoreConfig, sSettingsUtil } from '@ohos/frameworkwrapper';
import {
    GRID_LAYOUT_MAP_REPLACE_INFO_CONST,
    GridLayoutInfo,
    GridLayoutMapReplaceInfo,
    MappingTypeConstants,
    TempGridLayoutInfo,
    UpdateGirdLayoutReq
} from '../../bean/GridLayoutMapReplaceInfo';
import GridLayoutItemInfo from '../../bean/GridLayoutItemInfo';
import { DockItemInfo } from '../../bean/DockItemInfo';
import { AppItemInfo } from '../../bean/AppItemInfo';
import { launcherAbilityManager } from '../../abilitymanager/LauncherAbilityManager';
import { RdbStoreManager } from '../RdbStoreManager';
import { CommonConstants, DesktopLayoutState } from '../../constants/CommonConstants';
import { HomeRdbStoreManager } from '../HomeRdbStoreManager';
import { SimpleRdbStoreManager } from '../SimpleRdbStoreManager';

const TAG = 'GridLayoutDBMapReplaceCorrector';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 处理桌面图标映射方案
 * 目的：替换旧应用包名保存到数据库，使用新应用的包名替换老应用的位置；
 * 数据来源：配置文件内容由BMS开发提供。
 */
export class GridLayoutDBMapReplaceCorrector {
  /**
   * 允许处理的映射类型
   */
  private ALLOW_MAPPING_TYPE_LIST: number[] = [MappingTypeConstants.TYPE_APP];

  constructor() {
  }

  /**
   * 处理缓存和数据库数据
   * @param desktopItems 普通桌面数据
   * @param outerDesktopItems 外屏桌面数据
   * @param simpleDesktopItems 简易模式桌面数据
   * @param dockDesktopItems dock数据
   * @param simpleDockDesktopItems 简易模式dock数据
   * @returns
   */
  public async handleData(desktopItems: GridLayoutItemInfo[] | undefined,
    outerDesktopItems: GridLayoutItemInfo[] | undefined,
    simpleDesktopItems: GridLayoutItemInfo[] | undefined,
    dockDesktopItems: DockItemInfo[] | undefined,
    simpleDockDesktopItems: DockItemInfo[] | undefined): Promise<void> {
    let allowMapReplaces = await this.checkMapReplaces(GRID_LAYOUT_MAP_REPLACE_INFO_CONST.maps);
    if (CheckEmptyUtils.isEmptyArr(allowMapReplaces)) {
      log.showWarn('handleData mapReplaces is empty');
      return;
    }
    await this.updateDB(desktopItems, allowMapReplaces, RdbStoreConfig.gridLayoutInfo.tableName);
    await this.updateDB(outerDesktopItems, allowMapReplaces, RdbStoreConfig.outerGridLayoutInfo.tableName);
    await this.updateDB(simpleDesktopItems, allowMapReplaces, RdbStoreConfig.simpleLayoutInfo.tableName);
    await this.updateDB(dockDesktopItems, allowMapReplaces, RdbStoreConfig.gridLayoutInfo.tableName);
    await this.updateDB(simpleDockDesktopItems, allowMapReplaces, RdbStoreConfig.simpleLayoutInfo.tableName);
  }

  /**
   * 更新数据库
   * @param gridLayoutInfo
   * @param mapReplaces
   * @param tableName
   */
  private async updateDB(gridLayoutInfo: GridLayoutItemInfo[] | DockItemInfo[] | undefined,
    mapReplaces: GridLayoutMapReplaceInfo[],
    tableName: string): Promise<void> {
    try {
      if (!gridLayoutInfo || this.isEmptyArr(gridLayoutInfo)) {
        return;
      }
      log.showInfo(`updateDB gridLayoutInfo=${gridLayoutInfo.length}`);
      let updateReqGroup: UpdateGirdLayoutReq[][] = [];
      for (let oneMap of mapReplaces) {
        try {
          let updateReqs: UpdateGirdLayoutReq[] = [];
          this.buildUpdateReqs(oneMap, updateReqs, gridLayoutInfo, tableName);
          this.addUpdateReqGroup(tableName, updateReqs, updateReqGroup, oneMap);
        } catch (error) {
          log.showError(`updateDB buildUpdateReqs error = ${error?.name}, ${error?.code}, ${error?.message}`);
        }
      }
      await this.doUpdateGroup(tableName, updateReqGroup);
    } catch (error) {
      log.showError(`updateDB error =  ${error?.name}, ${error?.code}, ${error?.message}`);
    }
  }

  /**
   * 校验map常量是否允许执行替换工作
   * @param mapReplaces
   * @returns
   */
  private async checkMapReplaces(mapReplaces: GridLayoutMapReplaceInfo[]): Promise<GridLayoutMapReplaceInfo[]> {
    let res: GridLayoutMapReplaceInfo[] = [];
    for (let oneMap of mapReplaces) {
      let checkRes = await this.doCheckMapReplaces(oneMap);
      if (checkRes) {
        res.push(oneMap);
      }
    }
    return res;
  }

  private async doCheckMapReplaces(oneMap: GridLayoutMapReplaceInfo): Promise<boolean> {
    let typeRes = this.checkAllowMapping(oneMap.mappingType);
    if (!typeRes) {
      return false;
    }
    let appInfoFromBMS: AppItemInfo | undefined =
      await launcherAbilityManager.getAppInfoByBundleName(oneMap.newInfo?.bundleName);
    if (CheckEmptyUtils.isEmpty(appInfoFromBMS)) {
      log.showError(`doCheckMapReplaces BMS isEmpty bundleName=${oneMap.newInfo?.bundleName}`);
      return false;
    }
    return true;
  }

  private isEmptyArr(configFromRdb: GridLayoutItemInfo[] | DockItemInfo[]): boolean {
    if (configFromRdb === undefined || configFromRdb === null ||
      (Array.isArray(configFromRdb) && configFromRdb.length === 0)) {
      return true;
    }
    return false;
  }

  private async doUpdateGroup(lable: string, updateReqGroup: UpdateGirdLayoutReq[][]): Promise<void> {
    if (!CheckEmptyUtils.isEmptyArr(updateReqGroup)) {
      this.printDoUpdateGroup(lable, updateReqGroup);
      await RdbStoreManager.getInstance().updateBatchGridLayoutWithMapReplaceGroup(updateReqGroup);
    } else {
      log.showDebug(`updateReqGroup is empty ${lable}`);
    }
  }

  private checkAllowMapping(mappingType: number[]): boolean {
    if (CheckEmptyUtils.isEmptyArr(mappingType)) {
      return false;
    }
    for (let oneMapType of mappingType) {
      if (this.ALLOW_MAPPING_TYPE_LIST.indexOf(oneMapType) === -1) {
        return false;
      }
    }
    return true;
  }

  private checkIsItem(item: GridLayoutItemInfo | DockItemInfo,
    jsonConfigInfo: GridLayoutMapReplaceInfo): boolean {
    if (CheckEmptyUtils.isEmpty(item)) {
      log.showDebug('checkIsItem item is empty');
      return false;
    }
    if (jsonConfigInfo.mappingType.indexOf(item.typeId ?? -1) === -1) {
      return false;
    }
    return this.checkEquals(jsonConfigInfo, item);
  }

  private convert(source: GridLayoutItemInfo | DockItemInfo, target: GridLayoutInfo): void {
    source.bundleName = target.bundleName;
    source.moduleName = target.moduleName;
    source.abilityName = target.abilityName;
  }

  private checkEquals(jsonConfigInfo: GridLayoutMapReplaceInfo,
    oneItemFromDB: GridLayoutItemInfo | DockItemInfo): boolean {
    for (let oneOldInfo of jsonConfigInfo.oldInfo) {
      if (oneOldInfo.bundleName === oneItemFromDB.bundleName &&
        oneOldInfo.moduleName === oneItemFromDB.moduleName &&
        oneOldInfo.abilityName === oneItemFromDB.abilityName) {
        return true;
      }
    }
    return false;
  }

  private buildUpdateReqs(oneMap: GridLayoutMapReplaceInfo, updateReqs: UpdateGirdLayoutReq[],
    configFromRdb: GridLayoutItemInfo[] | DockItemInfo[], tableName: string): void {
    if (this.isEmptyArr(configFromRdb)) {
      log.showWarn('findGridLayoutItemFromDB is empty');
      return;
    }
    let datas: TempGridLayoutInfo[] = this.findGridLayoutItemFromDB(oneMap, configFromRdb);
    let req = this.buildUpdateGirdLayoutReq(datas, tableName, oneMap.newInfo);
    if (req) {
      updateReqs.push(req);
    }
  }

  private findGridLayoutItemFromDB(jsonConfigInfo: GridLayoutMapReplaceInfo,
    configFromRdb: GridLayoutItemInfo[] | DockItemInfo[]): TempGridLayoutInfo[] {
    let res: TempGridLayoutInfo[] = [];
    configFromRdb.forEach((item: GridLayoutItemInfo | DockItemInfo) => {
      if (item.typeId === CommonConstants.TYPE_FOLDER && item.layoutInfo && item.layoutInfo[0].length > 0) {
        let floderRes = this.findGridLayoutItemFromDB(jsonConfigInfo, item.layoutInfo[0]);
        if (!CheckEmptyUtils.isEmptyArr(floderRes)) {
          res = res.concat(floderRes);
        }
      } else if (this.checkIsItem(item, jsonConfigInfo)) {
        let temp = this.convertTempGridLayoutInfo(item);
        this.convert(item, jsonConfigInfo.newInfo);
        log.showWarn(`findGridLayoutItemFromDB after id=${item.id},bundleName=${item.bundleName},moduleName=${item.moduleName},abilityName=${item.abilityName},page=${item.page},row=${item.row},column=${item.column},container=${item.container}`);
        if (temp) {
          log.showInfo(`findGridLayoutItemFromDB temp=${this.tempToLog(temp)}`);
          res.push(temp);
        }
      }
    });
    return res;
  }

  private buildUpdateGirdLayoutReq(datas: TempGridLayoutInfo[], tableName: string,
    newInfo: GridLayoutInfo): UpdateGirdLayoutReq | null {
    if (CheckEmptyUtils.isEmptyArr(datas)) {
      log.showDebug('buildUpdateGirdLayoutReq datas is empty');
      return null;
    }
    let ids: number[] = [];
    datas.forEach(item => {
      if (!CheckEmptyUtils.isEmpty(item.id)) {
        ids.push(item.id);
      }
    });
    if (CheckEmptyUtils.isEmptyArr(ids)) {
      return null;
    }
    let oneReq: UpdateGirdLayoutReq = {
      tableName: tableName,
      ids: ids,
      newGridLayoutInfo: newInfo,
    };

    return oneReq;
  }

  private convertTempGridLayoutInfo(source: GridLayoutItemInfo | DockItemInfo): TempGridLayoutInfo | null {
    if (!CheckEmptyUtils.isEmpty(source)) {
      let res: TempGridLayoutInfo = {
        id: source.id ?? -1,
        typeId: source.typeId ?? -1,
        bundleName: source.bundleName,
        moduleName: source.moduleName ?? '',
        abilityName: source.abilityName,
        page: source.page ?? -1,
        row: source.row ?? 0,
        column: source.column ?? 0,
        container: source.container ?? -100
      };
      return res;
    }
    return null;
  }

  private addUpdateReqGroup(label: string, updateReqs: UpdateGirdLayoutReq[],
    updateReqGroup: UpdateGirdLayoutReq[][],
    oneMap: GridLayoutMapReplaceInfo): void {
    if (!CheckEmptyUtils.isEmptyArr(updateReqs)) {
      updateReqGroup.push(updateReqs);
    } else {
      log.showInfo(`addUpdateReqGroup ${label} updateReqs is empty. oneMap=${this.mapToLog(oneMap)}`);
    }
  }

  private printDoUpdateGroup(lable: string, updateReqs: UpdateGirdLayoutReq[][]): void {
    updateReqs?.forEach((item: UpdateGirdLayoutReq[]) => {
      item?.forEach((one: UpdateGirdLayoutReq) => {
        log.showWarn(`printDoUpdateGroup ${lable},${this.reqToLog(one)}`);
      });
    });
  }

  private mapToLog(data: GridLayoutMapReplaceInfo): string {
    let tmp: string = 'mappingType:[';
    tmp += data.mappingType?.toString();
    tmp += '], oldInfo:[';
    data.oldInfo?.forEach((item: GridLayoutInfo) => {
      tmp += this.infoToLog(item);
    });
    tmp += '], newInfo:(';
    tmp += this.infoToLog(data.newInfo);
    tmp += ')';
    return tmp;
  }

  private infoToLog(data: GridLayoutInfo): string {
    return [`bundleName:${data.bundleName}`, `moduleName:${data.moduleName}`,
      `abilityName:${data.abilityName}`].join(',');
  }

  private reqToLog(data: UpdateGirdLayoutReq): string {
    let tmp: string = 'tableName:' + data.tableName + ', ids:[';
    tmp += data.ids?.toString();
    tmp += '], newGridLayoutInfo:(';
    tmp += this.infoToLog(data.newGridLayoutInfo);
    tmp += ')';
    return tmp;
  }

  private tempToLog(data: TempGridLayoutInfo): string {
    return [
      `id:${data.id}`,
      `typeId:${data.typeId}`,
      `bundleName:${data.bundleName}`,
      `moduleName:${data.moduleName}`,
      `abilityName:${data.abilityName}`,
      `page:${data.page}`,
      `row:${data.row}`,
      `column:${data.column}`,
      `container:${data.container}`
    ].join(',');
  }
}

/**
 * 数据处理器的构造器
 */
export class GridLayoutDBMapReplaceCorrectorBuilder {
  private static instance: GridLayoutDBMapReplaceCorrectorBuilder;

  public static getInstance(): GridLayoutDBMapReplaceCorrectorBuilder {
    if (!GridLayoutDBMapReplaceCorrectorBuilder.instance) {
      GridLayoutDBMapReplaceCorrectorBuilder.instance = new GridLayoutDBMapReplaceCorrectorBuilder();
    }
    return GridLayoutDBMapReplaceCorrectorBuilder.instance;
  }

  /**
   * dock
   * 启动时，处理缓存和数据
   */
  async dockMapReplaceCorrector(isPC: boolean, dockDataList: DockItemInfo[]): Promise<void> {
    if (isPC) {
      return;
    }
    let desktopLayout: number = Number(sSettingsUtil.getValue(CommonConstants.SIMPLE_MODE_KEY, '0'));
    if (desktopLayout === DesktopLayoutState.SIMPLE_LAUNCHER_MODEL) {
      let homeDockItems: DockItemInfo[] = await HomeRdbStoreManager.getInstance().querySmartDock();
      await new GridLayoutDBMapReplaceCorrector().
        handleData(undefined, undefined, undefined, homeDockItems, dockDataList);
    } else {
      let simpleItems: DockItemInfo[] = await SimpleRdbStoreManager.getInstance().querySmartDock();
      await new GridLayoutDBMapReplaceCorrector().
        handleData(undefined, undefined, undefined, dockDataList, simpleItems);
    }
  }

  /**
   * 普通桌面
   * 启动时，处理缓存和数据
   */
  async pageDesktopMapReplaceCorrector(configFromRdb: GridLayoutItemInfo[],
    dockDataList: DockItemInfo[]): Promise<void> {
    const isPC: boolean = DeviceHelper.isPC();
    if (isPC) {
      return;
    }
    let desktopLayout: number = Number(sSettingsUtil.getValue(CommonConstants.SIMPLE_MODE_KEY, '0'));
    if (desktopLayout === DesktopLayoutState.SIMPLE_LAUNCHER_MODEL) {
      let desktopItems: GridLayoutItemInfo[] = await HomeRdbStoreManager.getInstance().queryGridLayoutInfo();
      let dockDesktopItems: DockItemInfo[] = await HomeRdbStoreManager.getInstance().querySmartDock();
      await new GridLayoutDBMapReplaceCorrector().handleData(desktopItems, undefined, configFromRdb, dockDesktopItems,
        dockDataList);
    } else {
      let simpleDesktopItems: GridLayoutItemInfo[] = await SimpleRdbStoreManager.getInstance().queryGridLayoutInfo();
      let simpleDockDesktopItems: DockItemInfo[] = await SimpleRdbStoreManager.getInstance().querySmartDock();
      await new GridLayoutDBMapReplaceCorrector().handleData(configFromRdb, undefined, simpleDesktopItems, dockDataList,
        simpleDockDesktopItems);
    }
  }

  /**
   * 外屏桌面
   * 启动时，处理缓存和数据
   */
  async outerPhonePageDesktopMapReplaceCorrector(configFromRdb: GridLayoutItemInfo[],
    dockDataList: DockItemInfo[], outerConfigFromRdb: GridLayoutItemInfo[]): Promise<void> {
    let desktopLayout: number = Number(sSettingsUtil.getValue(CommonConstants.SIMPLE_MODE_KEY, '0'));
    if (desktopLayout === DesktopLayoutState.SIMPLE_LAUNCHER_MODEL) {
      let desktopItems: GridLayoutItemInfo[] = await HomeRdbStoreManager.getInstance().queryGridLayoutInfo();
      let dockDesktopItems: DockItemInfo[] = await HomeRdbStoreManager.getInstance().querySmartDock();
      await new GridLayoutDBMapReplaceCorrector().handleData(desktopItems, outerConfigFromRdb, configFromRdb,
        dockDesktopItems,
        dockDataList);
    } else {
      let simpleDesktopItems: GridLayoutItemInfo[] = await SimpleRdbStoreManager.getInstance().queryGridLayoutInfo();
      let simpleDockDesktopItems: DockItemInfo[] = await SimpleRdbStoreManager.getInstance().querySmartDock();
      await new GridLayoutDBMapReplaceCorrector().handleData(configFromRdb, outerConfigFromRdb, simpleDesktopItems,
        dockDataList,
        simpleDockDesktopItems);
    }
  }
}