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

import { CheckEmptyUtils, ObjUtil } from '@ohos/basicutils';
import {
  bundleManagerFwk,
  ContextModifyUtils,
  dbCache,
  IconCacheInterface,
  IconResourceManager,
  memoryCache,
  RdbStoreConfig,
} from '@ohos/frameworkwrapper';
import Common from '@ohos.app.ability.common';
import {
  AppStatus,
  CommonConstants,
  DesktopParam,
  GridLayoutItemInfo
} from '@ohos/launchercommon/src/main/ets/TsIndex';
import GridLayoutInfoColumns from '@ohos/launchercommon/src/main/ets/db/column/GridLayoutInfoColumns';
import rdb from '@ohos.data.relationalStore';
import GridLayoutItemDbBuilder from '@ohos/launchercommon/src/main/ets/entity/GridLayoutItemDbBuilder';
import { bundleResourceManager, Context, contextConstant } from '@kit.AbilityKit';
import { HashMap, List, taskpool } from '@kit.ArkTS';
import { resourceManager } from '@kit.LocalizationKit';
import { NoIconAppModel } from '@ohos/launchercommon/src/main/ets/model/NoIconAppModel';
import { PreviewUtils } from './PreviewUtils';
import { Log } from './Log';
import type common from '@ohos.app.ability.common';
import { AppCategoryUtils } from '@ohos/launchercommon/src/main/ets/utils/AppCategoryUtils';

const TAG: string = 'DesktopPreviewRdbManager';

export class DesktopPreviewRdbManager {
  private mLauncherRdbStore: rdb.RdbStore | undefined = undefined;

  private mTableName: string = RdbStoreConfig.gridLayoutInfo.tableName;

  private mPreviewDataLoadFinishCallBack: Function | undefined;

  private mDesktopData: GridLayoutItemInfo[] = [];

  private mIsLoadFinished: boolean = false;

  private mDesktopPreviewContext: Common.Context | undefined;

  private constructor(desktopMode?: number) {
    if (desktopMode) {
      this.mTableName = desktopMode === 0 ? RdbStoreConfig.gridLayoutInfo.tableName :
        RdbStoreConfig.simpleLayoutInfo.tableName;
    }
  }

  static getInstance(desktopMode?: number): DesktopPreviewRdbManager {
    if (globalThis.desktopPreviewRdbManager == null) {
      globalThis.desktopPreviewRdbManager = new DesktopPreviewRdbManager(desktopMode);
    }
    return globalThis.desktopPreviewRdbManager;
  }

  public async createLauncherRdbStore(context: Common.Context): Promise<boolean> {
    if (this.mLauncherRdbStore !== undefined) {
      return true;
    }
    let result: boolean = true;
    let callback: Function = async (contextCallback: Context) => {
      try {
        const launcherStoreConfig: rdb.StoreConfig = {
          name: RdbStoreConfig.dbName,
          securityLevel: rdb.SecurityLevel.S1,
          haMode: rdb.HAMode.MAIN_REPLICA,
          allowRebuild: true,
          isSearchable: true,
        };
        this.mLauncherRdbStore = await rdb.getRdbStore(contextCallback, launcherStoreConfig);
      } catch (error) {
        result = false;
        Log.showError(TAG, `createLauncherRdbStore catch error: ${error}`);
      }
    };
    await ContextModifyUtils.modifyTargetContextAsync(context, contextConstant.AreaMode.EL1, callback,
      `${TAG}-createLauncherRdbStore`);
    return result;
  }

  public registerLoadFinishState(previewDataLoadFinishCallBack: Function): void {
    this.mPreviewDataLoadFinishCallBack = previewDataLoadFinishCallBack;
  }

  public unRegisterLoadFinishState(): void {
    this.mPreviewDataLoadFinishCallBack = undefined;
  }

  public queryFirstScreenData(): GridLayoutItemInfo[] {
    return this.mDesktopData.filter(item => item.page === 0);
  }

  public initIconResourceCache(): void {
    let cacheList: List<IconCacheInterface> = new List();
    cacheList.add(memoryCache);
    cacheList.add(dbCache);
    IconResourceManager.getInstance().initCacheList(cacheList, bundleManagerFwk);
  }

  public async initIconName(): Promise<void> {
    try {
      let abilityInfoList =
       await taskpool.execute(getAllLauncherAbilityInfo) as bundleResourceManager.LauncherAbilityResourceInfo[];
      abilityInfoList.forEach((info: bundleResourceManager.LauncherAbilityResourceInfo) => {
        if (!PreviewUtils.checkStrIsEmpty(info.label)) {
          IconResourceManager.getInstance().setNameResourceCache(info.bundleName,
            info.moduleName, info.abilityName, info.label, info.appIndex);
        }
      });
      Log.showInfo(TAG, `initIconNameCache abilityInfoList size ${abilityInfoList.length}`);
    } catch (err) {
      Log.showError(TAG, 'initIconNameCache error ' + err);
    }
  }

  public initDesktopData(context: Common.Context, isFold: boolean): void {
    this.mDesktopPreviewContext = context;
    let callback: Function = (contextCallback: Context) => {
      this.createLauncherRdbStore(contextCallback).then(( result : boolean) => {
        if (!result) {
          return;
        }
        this.mDesktopData = this.queryGridLayoutItemInfos(this.mTableName, isFold);
        this.mIsLoadFinished = true;
        if (this.mPreviewDataLoadFinishCallBack && this.mIsLoadFinished) {
          this.mPreviewDataLoadFinishCallBack(this.queryFirstScreenData());
          this.mIsLoadFinished = false;
          this.mPreviewDataLoadFinishCallBack = undefined;
        }
      });
    };
    ContextModifyUtils.modifyTargetContext(this.mDesktopPreviewContext, contextConstant.AreaMode.EL1, callback,
      `${TAG}-initDesktopData`, false);
  }

  public getIsLoadFinishState(): boolean {
    return this.mIsLoadFinished;
  }

  private dealResultSet(returnList: GridLayoutItemInfo[], resultSet: rdb.ResultSet,
    stackMap: HashMap<number, GridLayoutItemInfo[]>): void {
    let container = resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.CONTAINER));
    let typeId = resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.TYPE_ID));

    // 查询桌面
    if (container === CommonConstants.CONTAINER_DESKTOP) {
      let gridLayoutInfo: GridLayoutItemInfo =
        GridLayoutItemDbBuilder.fromResultSet(resultSet).buildGridLayoutItemDB().toGridLayoutItemInfo();
      returnList.push(gridLayoutInfo);
    } else if (container !== CommonConstants.CONTAINER_DESKTOP && typeId === CommonConstants.TYPE_CARD) {
      // 处理堆叠中的卡片
      let cards: GridLayoutItemInfo[] = [];
      if (stackMap.hasKey(container)) {
        cards = stackMap.get(container);
      } else {
        stackMap.set(container, cards);
      }
      let itemDb: GridLayoutItemInfo = GridLayoutItemDbBuilder.fromResultSet(resultSet)
        .buildGridLayoutItemDB().toGridLayoutItemInfo();
      cards.push(itemDb);
    }
  }

  private queryGridLayoutItemInfos(tableName: string, isFold: boolean): GridLayoutItemInfo[] {
    let returnList: GridLayoutItemInfo[] = [];
    if (!this.mLauncherRdbStore) {
      Log.showError(TAG, 'mLauncherRdbStore undefined return');
      return returnList;
    }
    const predicates = new rdb.RdbPredicates(tableName);

    predicates.beginWrap();
    if (isFold) {
      predicates.beginWrap();
      predicates.equalTo(GridLayoutInfoColumns.PAGE_INDEX, 0);
      predicates.or();
      predicates.equalTo(GridLayoutInfoColumns.PAGE_INDEX, 1);
      predicates.endWrap();
    } else {
      predicates.equalTo(GridLayoutInfoColumns.PAGE_INDEX, 0);
    }
    predicates.endWrap();
    predicates.or();
    predicates.equalTo(GridLayoutInfoColumns.TYPE_ID, CommonConstants.TYPE_CARD);

    let stackMap: HashMap<number, GridLayoutItemInfo[]> = new HashMap();
    try {
      let resultSet: rdb.ResultSet = this.mLauncherRdbStore.querySync(predicates, []);
      while (resultSet.goToNextRow()) {
        this.dealResultSet(returnList, resultSet, stackMap);
      }
      resultSet.close();
    } catch (e) {
      Log.showError(TAG, `queryGridLayoutInfo error[${e.code}]: ${e.message}`);
    }
    returnList.filter((item: GridLayoutItemInfo) => item.typeId === CommonConstants.TYPE_FORM_STACK)
      .forEach((item: GridLayoutItemInfo) => {
        if (!item.layoutInfo) {
          item.layoutInfo = [];
        }
        if (stackMap.hasKey(item.id)) {
          item.layoutInfo.push(stackMap.get(item.id));
        } else {
          Log.showInfo(TAG, 'the formStack data is error');
          item.layoutInfo.push([]);
        }
      });
    Log.showInfo(TAG, `queryGridLayoutInfo end ${returnList.length}`);
    return returnList;
  }

  public getItemName(item: GridLayoutItemInfo, desktopParam: DesktopParam, callBack?: Function): void {
    if (PreviewUtils.isEmpty(item) && callBack) {
      callBack(item.appName);
      return;
    }
    let res: string = '';
    if (NoIconAppModel.getInstance().checkIfBundleIsNoIconApp(item.bundleName) && callBack) {
      res = NoIconAppModel.getInstance().updateNoIconAppInfo(item.bundleName).label;
      callBack(res);
      return;
    }
    res = this.getAppNameWithCache(item.appLabelId, item.bundleName, item.moduleName, res, item.appIndex);
    if (PreviewUtils.isEmpty(res) && callBack) {
      this.getBundleLabelWithCache(item.appLabelId ?? 0, item.bundleName, item.moduleName ?? '', res, callBack);
      return;
    }
    if (callBack) {
      callBack(res);
    }
  }

  getAppNameWithCache(labelId?: number, bundleName?: string, moduleName?: string, appName?: string, appIndex?: number):
    string {
    let res: string = '';
    if (!labelId) {
      Log.showInfo(TAG, `getAppNameWithCache labelId is invalid appName: ${appName}, bundleName:${bundleName}`);
      return res;
    }
    let resMgr: resourceManager.ResourceManager | undefined = undefined;
    try {
      Log.showInfo(TAG, `getAppNameWithCache bundleName:${bundleName}, moduleName:${moduleName}, labelId:${labelId}`);
      resMgr = this.mDesktopPreviewContext?.createModuleResourceManager(bundleName, moduleName);
      resMgr?.getStringValue(labelId, (error, value) => {
        if (error != null || PreviewUtils.checkStrIsEmpty(value)) {
          Log.showInfo(TAG, `getAppNameWithCache getAppName getString ERROR! value is empty id ${labelId} bundleName:${bundleName}`);
          res = appName ?? '';
        } else {
          res = `${value}${(appIndex ?? 0) > 0 ? appIndex : ''}`;
        }
        return res;
      });
    } catch (err) {
      Log.showError(TAG, `getAppNameWithCache error:${err} bundleName:${bundleName}, labelId:${labelId}`);
    } finally {
      if (resMgr) {
        // MemoryUtils.removeNapiWrap(resMgr, false);
      }
    }
    return res;
  }

  getBundleLabelWithCache(labelId: number, bundleName: string, moduleName: string, appName: string, callBack: Function):
    void {
    let res: string = appName;
    if (!labelId) {
      Log.showInfo(TAG, `getBundleLabelWithCache invalid labelId:${labelId}`);
      callBack(res);
    }
    try {
      Log.showDebug(TAG, `getBundleLabelWithCache bundleName:${bundleName}, moduleName:${moduleName} labelId:${labelId}, appName${appName}`);
      let bundleContext = this.mDesktopPreviewContext?.createBundleContext(bundleName);
      bundleContext?.resourceManager.getStringValue(labelId, (error, value) => {
        if (error != null || PreviewUtils.checkStrIsEmpty(value)) {
          Log.showError(TAG, `getBundleLabelWithCache getStringValue ERROR! labelId:${labelId}`, error);
          res = appName;
        } else {
          res = value;
        }
        // MemoryUtils.removeNapiWrap(bundleContext, false);
        callBack(res);
      });
    } catch (err) {
      Log.showError(TAG, 'getBundleLabelWithCache error:', err);
      callBack(appName);
    }
  }

  /**
   * 获取文件夹真实名称
   *
   * @returns folder name after replace i18n value.
   */
  public getRealFolderName(originFolderName: string): string {
    if (ObjUtil.isInvalid(originFolderName)) {
      return originFolderName;
    }
    let isIntelFolder: boolean = originFolderName.startsWith('#');
    if (isIntelFolder) {
      let realFoldrName = AppCategoryUtils.getIntelFolderName(originFolderName);
      Log.showInfo(TAG, `getRealFolderName realFoldrName: ${realFoldrName}`);
      if (!CheckEmptyUtils.checkStrIsEmpty(realFoldrName)) {
        return realFoldrName;
      }
    }
    let reg: RegExp = /^\$\{([^{}]+)\}(.*)/;
    let ret: RegExpMatchArray | null = originFolderName.match(reg);
    if (ret) {
      if (ret.length === 2) {
        return this.getStringByName(ret[1]);
      } else if (ret.length === 3 ) {
        return this.getStringByName(ret[1], parseInt(ret[2]) || 1);
      }
    }
    return originFolderName;
  }

  /**
   * 通过资源名称获取字符串
   *
   * @param name 资源名称
   * @returns 字符串
   */
  getStringByName(name: string, ...params: (string | number)[]): string {
    let result = '';
    try {
      result = this.mDesktopPreviewContext?.resourceManager.getStringByNameSync(name, ...params) ?? '';
    } catch (err) {
      Log.showError(TAG, 'getStringByName error:', err);
    }
    return result;
  }
}

/**
 * 异步线程-更新桌面布局表中的info_name，且返回应用列表信息
 *
 * @returns LauncherAbilityResource列表
 */
async function getAllLauncherAbilityInfo(): Promise<bundleResourceManager.LauncherAbilityResourceInfo[]> {
  'use concurrent';
  let result: bundleResourceManager.LauncherAbilityResourceInfo[] = [];
  try {
    result =
      await bundleResourceManager.getAllLauncherAbilityResourceInfo(
        bundleResourceManager.ResourceFlag.GET_RESOURCE_INFO_WITH_LABEL);
  } catch (err) {
    Log.showError('DesktopPreviewRdbManager', 'getAllLauncherAbilityInfo error:', err);
  }
  return result;
}