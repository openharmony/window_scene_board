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

import taskPool from '@ohos.taskpool';
import rdb from '@ohos.data.relationalStore';
import { LogDomain, LogHelper, CheckEmptyUtils, SingleContext } from '@ohos/basicutils';
import { DeviceHelper, GlobalContext, HiSysEventUtil, rdbStoreHelper } from '@ohos/frameworkwrapper';
import BadgeItemInfo from '../bean/BadgeItemInfo';
import type GridLayoutItemInfo from '../bean/GridLayoutItemInfo';
import { CardItemInfo } from '../bean/CardItemInfo';
import { SwiperItemInfo } from '../entity/SwiperItemInfo';
import GridLayoutItemInfoDB from '../entity/GridLayoutItemInfoDataBase';
import GridLayoutItemDbBuilder from '../entity/GridLayoutItemDbBuilder';
import GridLayoutInfoColumns, { GridLayoutInfoEnums } from './column/GridLayoutInfoColumns';
import type Context from '@ohos.app.ability.common';
import { DockItemInfo } from '../bean/DockItemInfo';
import { LockPreference } from '../utils//RecentLockUtils';
import type { DownloadInfoItem } from '../constants/CommonConstants';
import { AppStatus } from '../constants/CommonConstants';
import { CommonConstants } from '../constants/CommonConstants';
import RecentDockInfoColumns from './column/RecentDockInfoColumns';
import RecentLockInfoColumns from './column/recentLockInfoColumns';
import RecentDockLayoutInfoColumns, { RecentDockLayoutInfoEnums } from './column/RecentDockLayoutInfoColumns';
import { HandleType, MINOR_COUNT, handleDataInfo } from './RdbTaskPoolHelper';
import { AppGridItemInfo } from '../bean/AppGridItemInfo';
import { UpdateGirdLayoutReq, UpdateGirdLayoutReqUtil } from '../bean/GridLayoutMapReplaceInfo';
import PageIndexTypeInfo from '../bean/PageIndexTypeInfo';
// import { appInfoManager } from '@kit.StoreKit';
import AppCategoryInfoColumns from './column/AppCategoryInfoColumns';
import { AppCategoryUtils } from '../utils/AppCategoryUtils';
import { RecentLockUtils } from '../utils/RecentLockUtils';
import { ObjectCopyUtil } from '@ohos/componenthelper/src/main/ets/TsIndex';
import { RdbStoreHelper } from '@ohos/frameworkwrapper/src/main/ets/service/db/RdbStoreHelper';
import { SceneMsgEnum } from '../utils/SceneMsgUtils';
import { FormCommonUtil } from '../utils/FormCommonUtil';
import { RdbLogUtils } from './RdbLogUtils';
import GridLayoutUtil from '../utils/GridLayoutUtil';

const TAG = 'RdbTaskPool';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 数据库操作子线程实现
 * 1.taskPool只支持传递可序列化对象，无法使用类函数
 * 2.rdb.RdbPredicates无法传入，传入map生成rdb.RdbPredicates
 * 3.rdb.ResultSet无法传出，在子线程函数中转为bean或者array传出，故所有query需在RdbTaskPool实现
 * 4.rdb.RdbStore无法传入，线程会重新获取，事务必须写在RdbTaskPool，否则可能不是同一rdb.RdbStore对象
 */
export default class RdbTaskPool {
  // 正在开机标识；开机时大量查询操作会创建多个taskpool，导致内存增高，该场景下使用SequenceRunner；当前仅手机支持
  private isStartingUp: boolean = false;
  // 读操作SequenceRunner
  private readRunner: taskPool.SequenceRunner = new taskPool.SequenceRunner(taskPool.Priority.MEDIUM);
  // 增删改操作SequenceRunner
  private writeRunner: taskPool.SequenceRunner = new taskPool.SequenceRunner(taskPool.Priority.MEDIUM);

  /**
   * db helper instance
   *
   * @return rdbStoreHelper instance
   */
  public static getInstance(): RdbTaskPool {
    if (globalThis.RdbTaskPoolInstance == null) {
      globalThis.RdbTaskPoolInstance = new RdbTaskPool();
    }
    return globalThis.RdbTaskPoolInstance;
  }

  /**
   * 设置开机状态
   * @param status 是否正在开机
   */
  public setStartupStatus(status: boolean): void {
    if (!DeviceHelper.isPhone()) {
      return;
    }
    this.isStartingUp = status;
    log.showInfo('set startup status, isStartingUp: %{public}s', status);
  }

  /**
   * 插入操作
   *
   * @param tableName 表名
   * @param valuesBucket 数据
   * @returns 插入行数
   */
  public async insert(tableName: string, valuesBucket: rdb.ValuesBucket,
    sceneMsg: string = SceneMsgEnum.RDB_DEFAULT_INSERT): Promise<number> {
    const taskInfo: TaskInfo = new TaskInfo('insert', insert, TaskType.INSERT);
    return await this.doTask(taskInfo, tableName, valuesBucket, sceneMsg) as number;
  }

  /**
   * 批量插入操作
   *
   * @param tableName 表名
   * @param valuesBucket 插入到表中的一组数据
   * @returns 返回插入的数据个数
   */
  public async batchInsert(tableName: string, insertBucketList: Array<rdb.ValuesBucket>,
    sceneMsg: string = SceneMsgEnum.RDB_DEFAULT_BATCH_INSERT): Promise<number> {
    const taskInfo: TaskInfo = new TaskInfo('batchInsert', batchInsert, TaskType.INSERT);
    return await this.doTask(taskInfo, tableName, insertBucketList, sceneMsg) as number;
  }

  /**
   * 更新新安装的应用
   *
   * @param target 表名
   * @param conditions 更新条件
   * @param valuesBucket 更新数据
   * @returns 受影响行数
   */
  public async updateNewInstalledApp(target: string, gridlayoutInfo: GridLayoutItemInfo,
    sceneMsg: string = SceneMsgEnum.RDB_DEFAULT_UPDATE): Promise<number> {
    if (CheckEmptyUtils.isEmpty(gridlayoutInfo)) {
      return CommonConstants.INVALID_VALUE;
    }
    const taskInfo: TaskInfo = new TaskInfo('updateNewInstalledApp', updateNewInstalledApp, TaskType.UPDATE);
    let updates = <number> await this.doTask(taskInfo, target, gridlayoutInfo, sceneMsg);
    if (updates === 0) {
      log.showError('appInstall updateNewInstalledApp error! target:%{public}s appInfo:%{public}s',
        target, JSON.stringify(gridlayoutInfo));
    } else {
      log.showWarn('appInstall updateNewInstalledApp bundleName:%{public}s updateRows:%{public}d',
        gridlayoutInfo.bundleName, updates);
    }
    return updates;
  }

  /**
   * 更新操作
   *
   * @param tableName 表名
   * @param conditions 更新条件
   * @param valuesBucket 更新数据
   * @returns 受影响行数
   */
  public async update(tableName: string, conditions: Map<string, rdb.ValueType>,
    valuesBucket: rdb.ValuesBucket, sceneMsg: string = SceneMsgEnum.RDB_DEFAULT_UPDATE): Promise<number> {
    if (CheckEmptyUtils.isEmpty(conditions)) {
      return CommonConstants.INVALID_VALUE;
    }
    const taskInfo: TaskInfo = new TaskInfo('updateWithEqual', updateWithEqual, TaskType.UPDATE);
    return await this.doTask(taskInfo, tableName, conditions, valuesBucket, sceneMsg) as number;
  }

  /**
   * 按业务层的更新条件将符合条件的数据更新至数据库
   *
   * @param predicates 需要更新数据的条件，由业务层自行构造
   * @param valuesBucket 需要更新的数据
   * @returns 受影响行数
   */
  public async updatePredicates(predicates: rdb.RdbPredicates, valuesBucket: rdb.ValuesBucket,
    sceneMsg: string = SceneMsgEnum.RDB_DEFAULT_UPDATE, tableName?: string): Promise<number> {
    const taskInfo: TaskInfo = new TaskInfo('updateWithPredicates', updateWithPredicates, TaskType.UPDATE);
    return await this.doTask(taskInfo, predicates, valuesBucket, sceneMsg, tableName) as number;
  }

  /**
   * 删除操作
   *
   * @param tableName 表名
   * @param conditions 删除条件
   * @returns 受影响行数
   */
  public async delete(tableName: string, conditions: Map<string, rdb.ValueType>,
    sceneMsg: string = SceneMsgEnum.RDB_DEFAULT_DELETE): Promise<number> {
    if (CheckEmptyUtils.isEmpty(conditions)) {
      return CommonConstants.INVALID_VALUE;
    }
    const taskInfo: TaskInfo = new TaskInfo('deleteWithEqual', deleteWithEqual, TaskType.DELETE);
    return await this.doTask(taskInfo, tableName, conditions, sceneMsg) as number;
  }

  /**
   * 插入布局信息
   *
   * @param tableName 表名
   * @param gridItemList 布局信息列表
   * @returns 是否成功
   */
  public async insertGridLayoutInfo(tableName: string, gridItemList: GridLayoutItemInfo[],
    sceneMsg: string = SceneMsgEnum.RDB_DEFAULT_INSERT, ctx?: SingleContext): Promise<boolean> {
    const taskInfo: TaskInfo = new TaskInfo('insertGridLayoutInfo', insertGridLayoutInfo, TaskType.INSERT);
    try {
      return await this.doExceptionTask(taskInfo, tableName,
        gridItemList, sceneMsg, ctx?.extendScreenId ?? 0) as boolean;
    } catch (e) {
      if (e.code === 10200006) {
        return await this.doTask(taskInfo, tableName,
          ObjectCopyUtil.deepClone(gridItemList), sceneMsg, ctx?.extendScreenId ?? 0) as boolean;
      }
      return false;
    }
  }

  /**
   * 插入布局信息并返回数据库id
   *
   * @param tableName 表名
   * @param gridItemList 布局信息列表
   * @returns insert后的id
   */
  public async insertLayoutInfoNotExist(tableName: string, gridItem: GridLayoutItemInfo,
    sceneMsg: string = SceneMsgEnum.RDB_DEFAULT_INSERT): Promise<number> {
    const taskInfo: TaskInfo = new TaskInfo('insertLayoutInfoNotExist', insertLayoutInfoNotExist, TaskType.INSERT);
    return await this.doTask(taskInfo, tableName, gridItem, sceneMsg) as number;
  }

  /**
   * 插入应用中心布局信息
   *
   * @param tableName 表名
   * @param gridItemList 布局信息列表
   * @returns 是否成功
   */
  public async insertAppCenter(tableName: string, appGridItemList: AppGridItemInfo[],
    sceneMsg: string = SceneMsgEnum.RDB_DEFAULT_INSERT): Promise<boolean> {
    const taskInfo: TaskInfo = new TaskInfo('insertAppCenter', insertAppCenter, TaskType.INSERT);
    return await this.doTask(taskInfo, tableName, appGridItemList, sceneMsg) as boolean;
  }

  /**
   * 更新布局包信息
   *
   * @param updateReqGroup 更新语句
   * @returns 是否成功
   */
  public async updateBatchGridLayoutWithMapReplaceGroup(updateReqGroup: UpdateGirdLayoutReq[][],
    sceneMsg: string = SceneMsgEnum.RDB_DEFAULT_UPDATE): Promise<void> {
    const taskInfo: TaskInfo = new TaskInfo('updateBatchGridLayoutWithMapReplaceGroup', updateBatchGridLayoutWithMapReplaceGroup, TaskType.UPDATE);
    await this.doTask(taskInfo, updateReqGroup, sceneMsg);
  }

  /**
   * 更新布局位置
   *
   * @param tableName 表名
   * @param gridItemList 布局信息列表
   * @returns 是否成功
   */
  public async updateGridLayoutPositionBatch(tableName: string, gridItemList: GridLayoutItemInfo[],
    sceneMsg: string = SceneMsgEnum.RDB_DEFAULT_UPDATE): Promise<boolean> {
    const taskInfo: TaskInfo = new TaskInfo('updateGridLayoutPositionBatch', updateGridLayoutPositionBatch, TaskType.UPDATE);
    try {
      let res = await this.doExceptionTask(taskInfo, tableName, gridItemList, sceneMsg) as boolean;
      return res;
    } catch (e) {
      if (e.code === 10200006) {
        log.showError(`updateGridLayoutPositionBatch has symbol:${GridLayoutUtil.hasSymbol(gridItemList)}`);
        return await this.doTask(taskInfo, tableName, ObjectCopyUtil.deepClone(gridItemList), sceneMsg) as boolean;
      }
    }
    return false;
  }

  /**
   * 批量插入应用分类信息
   *
   * @param appCatInfoList 待更新的应用分类信息列表
   * @returns 是否成功
   */
  // public async batchInsertOrUpdateAppCatInfo(tableName: string, appCatInfoList: appInfoManager.AppCategoryInfo[],
  //   sceneMsg: string = SceneMsgEnum.RDB_DEFAULT_BATCH_INSERT):
  //   Promise<boolean> {
  //   const taskInfo: TaskInfo = new TaskInfo('batchInsertOrUpdateAppCatInfo', batchInsertOrUpdateAppCatInfo, TaskType.INSERT);
  //   return await this.doTask(taskInfo, tableName, appCatInfoList, sceneMsg) as boolean;
  // }

  /**
   * 批量更新应用加桌上限数量
   */
  public async batchUpdateLayoutInfoShortcutLimit(tableName: string, gridInfos: GridLayoutItemInfo[],
    sceneMsg: string = SceneMsgEnum.RDB_DEFAULT_UPDATE): Promise<boolean> {
    const taskInfo: TaskInfo = new TaskInfo('batchUpdateLayoutInfoShortcutLimit', batchUpdateLayoutInfoShortcutLimit, TaskType.INSERT);
    return await this.doTask(taskInfo, tableName, gridInfos, sceneMsg) as boolean;
  }

  /**
   * 查询应用的分类信息
   *
   * @param tableName 表名
   * @param conditions 条件
   * @returns 应用分类信息列表
   */
  // public async queryAppCatInfo(tableName: string, conditions: Map<string, rdb.ValueType>):
  //   Promise<appInfoManager.AppCategoryInfo[]> {
  //   const taskInfo: TaskInfo = new TaskInfo('queryAppCatInfo', queryAppCatInfo, TaskType.QUERY);
  //   let result: appInfoManager.AppCategoryInfo[] =
  //     await this.doTask(taskInfo, tableName, conditions) as appInfoManager.AppCategoryInfo[];
  //   return result === undefined ? [] : result;
  // }

  /**
   * 获取所有加锁应用的信息
   * @param { string} tableName - 表名.
   * @param { Map<string, rdb.ValueType> } conditions - 查询条件.
   */
  public async queryRecentLock(tableName: string, conditions: Map<string, rdb.ValueType>):
    Promise<LockPreference[]> {
    const taskInfo: TaskInfo = new TaskInfo('queryRecentLock', queryRecentLock, TaskType.QUERY);
    let result: LockPreference[] =
      await this.doTask(taskInfo, tableName, conditions) as LockPreference[];
    return result === undefined ? [] : result;
  }

  /**
   * 更新应用中心图标位置信息
   *
   * @param tableName 表名
   * @param gridItemList 布局信息列表
   * @returns 是否成功
   */
  public async updateAppCenterItemPositions(tableName: string, appGridItemList: AppGridItemInfo[],
    sceneMsg: string = SceneMsgEnum.RDB_DEFAULT_UPDATE): Promise<boolean> {
    const taskInfo: TaskInfo = new TaskInfo('updateAppCenterItemPositions', updateAppCenterItemPositions, TaskType.UPDATE);
    return await this.doTask(taskInfo, tableName, appGridItemList, sceneMsg) as boolean;
  }

  /**
   * 更新应用中心基础信息（不更新坐标相关）
   *
   * @param tableName 表名
   * @param gridItemList 布局信息列表
   * @returns 是否成功
   */
  public async updateAppCenterItemSys(tableName: string, appGridItemList: AppGridItemInfo[],
    sceneMsg: string = SceneMsgEnum.RDB_DEFAULT_UPDATE): Promise<boolean> {
    const taskInfo: TaskInfo = new TaskInfo('updateAppCenterItemSys', updateAppCenterItemSys, TaskType.UPDATE);
    return await this.doTask(taskInfo, tableName, appGridItemList, sceneMsg) as boolean;
  }

  /**
   * 插入dock
   *
   * @param tableName 表名
   * @param dockInfoList dock布局信息列表
   * @returns 是否成功
   */
  public async insertIntoSmartdock(dockInfoList: DockItemInfo[], tableName: string,
    sceneMsg: string = SceneMsgEnum.RDB_DEFAULT_INSERT): Promise<boolean> {
    const taskInfo: TaskInfo = new TaskInfo('insertIntoSmartDock', insertIntoSmartDock, TaskType.INSERT);
    return await this.doTask(taskInfo, dockInfoList, tableName, sceneMsg) as boolean;
  }

  /**
   * 插入dock栏的最近任务区
   *
   * @param recentDockList 最近任务区列表
   * @param tableName 表名
   * @returns 是否成功
   */
  public async insertIntoRecentDock(recentDockList: DockItemInfo[], tableName: string,
    sceneMsg: string = SceneMsgEnum.RDB_DEFAULT_INSERT): Promise<boolean> {
    const taskInfo: TaskInfo = new TaskInfo('insertIntoRecentDock', insertIntoRecentDock, TaskType.INSERT);
    return await this.doTask(taskInfo, recentDockList, tableName, sceneMsg) as boolean;
  }

  /**
   * 插入dock栏的最近任务区数量
   *
   * @param visibleCount 最近任务区列表
   * @param tableName 表名
   * @returns 是否成功
   */
  public async insertIntoRecentDockInfo(visibleCount: number, tableName: string,
    sceneMsg: string = SceneMsgEnum.RDB_DEFAULT_INSERT): Promise<boolean> {
    const taskInfo: TaskInfo = new TaskInfo('insertIntoRecentDockInfo', insertIntoRecentDockInfo, TaskType.INSERT);
    return await this.doTask(taskInfo, tableName, sceneMsg) as boolean;
  }

  /**
   * 查询dock
   *
   * @param tableName 表名
   * @returns dock布局信息列表
   */
  public async querySmartDock(tableName: string): Promise<DockItemInfo[]> {
    const taskInfo: TaskInfo = new TaskInfo('querySmartDock', querySmartDock, TaskType.QUERY);
    return await this.doTask(taskInfo, tableName) as DockItemInfo[];
  }

  /**
   * 查询Dock的最近任务区列表
   *
   * @param tableName 表名
   * @returns 最近任务应用列表
   */
  public async queryRecentDock(tableName: string): Promise<DockItemInfo[]> {
    const taskInfo: TaskInfo = new TaskInfo('queryRecentDock', queryRecentDock, TaskType.QUERY);
    return await this.doTask(taskInfo, tableName) as DockItemInfo[];
  }

  /**
   * 查询首页桌面应用和dock栏应用信息
   *
   * @param tableName 表名
   * @returns 首页桌面应用和dock栏应用信息，不包含文件夹内容
   */
  public async queryFirstPageAndDockApplication(tableName: string): Promise<GridLayoutItemInfo[]> {
    const taskInfo: TaskInfo = new TaskInfo('queryFirstPageAndDockApplication', queryFirstPageAndDockApplication, TaskType.QUERY);
    let result: GridLayoutItemInfo[] = await this.doTask(taskInfo, tableName) as GridLayoutItemInfo[];
    return result === undefined ? [] : result;
  }

  /**
   * 查询应用中心布局信息
   * @param tableName 表名
   * @returns
   */
  public async queryAppCenter(tableName: string): Promise<AppGridItemInfo[]> {
    const taskInfo: TaskInfo = new TaskInfo('queryAppCenter', queryAppCenter, TaskType.QUERY);
    return await this.doTask(taskInfo, tableName) as AppGridItemInfo[];
  }

  /**
   *查询Dock区的最近任务应用数量
   *
   * @param tableName 表名
   * @returns 最近任务应用列表
   */
  public async queryRecentDockInfo(tableName: string): Promise<number> {
    const taskInfo: TaskInfo = new TaskInfo('queryRecentDockInfo', queryRecentDockInfo, TaskType.QUERY);
    return await this.doTask(taskInfo, tableName) as number;
  }

  /**
   * 按类型查找布局信息
   *
   * @param tableName 表名
   * @param typeId 元素类型
   * @returns 布局信息列表
   */
  public async queryGridLayoutByType(tableName: string, typeId: number): Promise<GridLayoutItemInfo[]> {
    const taskInfo: TaskInfo = new TaskInfo('queryGridLayoutByType', queryGridLayoutByType, TaskType.QUERY);
    return await this.doTask(taskInfo, tableName, typeId) as GridLayoutItemInfo[];
  }

  /**
   * 按位置查找布局信息
   *
   * @param tableName 表名
   * @param container 元素位置
   * @returns 布局信息列表
   */
  public async queryGridLayoutByContainer(tableName: string, container: number): Promise<GridLayoutItemInfo[]> {
    const taskInfo: TaskInfo = new TaskInfo('queryGridLayoutByContainer', queryGridLayoutByContainer, TaskType.QUERY);
    return await this.doTask(taskInfo, tableName, container) as GridLayoutItemInfo[];
  }

  /**
   * 按位置更新布局信息
   *
   * @param tableName 表名
   * @param itemInfoList 更新数据
   * @param container 元素位置
   * @param isConvertToSmall 是否转变为小文件夹
   * @returns 是否成功
   */
  public async updateInfoPosition(tableName: string, itemInfoList: GridLayoutItemInfo[],
    container?: number, sceneMsg: string = SceneMsgEnum.RDB_DEFAULT_UPDATE, reason?: String, ctx?: SingleContext):
    Promise<boolean> {
    const taskInfo: TaskInfo = new TaskInfo('handleDataInfo', handleDataInfo, TaskType.UPDATE);
    try {
      let res = await this.doExceptionTask(taskInfo, tableName, itemInfoList,
        DeviceHelper.isPC() || itemInfoList.length <= MINOR_COUNT ?
        HandleType.MINOR_UPDATE : HandleType.MASS_UPDATE, container, ctx?.extendScreenId, reason) as boolean;
      return res;
    } catch (e) {
      if (e.code === 10200006) {
        log.showError(`updateInfoPosition has symbol:${GridLayoutUtil.hasSymbol(itemInfoList)}`);
        return await this.doTask(taskInfo, tableName, ObjectCopyUtil.deepClone(itemInfoList),
          DeviceHelper.isPC() || itemInfoList.length <= MINOR_COUNT ?
          HandleType.MINOR_UPDATE : HandleType.MASS_UPDATE, container, ctx?.extendScreenId, reason) as boolean;
      }
    }
    return false;
  }

  /**
   * 查询角标信息
   *
   * @param tableName 表名
   * @param conditions 条件
   * @returns 角标信息列表
   */
  public async queryBadge(tableName: string, conditions?: Map<string, rdb.ValueType>): Promise<BadgeItemInfo[]> {
    const taskInfo: TaskInfo = new TaskInfo('queryBadge', queryBadge, TaskType.QUERY);
    let result: BadgeItemInfo[] | undefined =
      await this.doTask(taskInfo, tableName, conditions as Object) as BadgeItemInfo[];
    return result === undefined ? [] : result;
  }

  /**
   * 查询空白页信息
   *
   * @param tableName 表名
   * @param conditions 条件
   * @returns 空白页信息列表
   */
  public async queryPageIndexTypeInfo(tableName: string, conditions?: Map<string, rdb.ValueType>):
    Promise<PageIndexTypeInfo[]> {
    const taskInfo: TaskInfo = new TaskInfo('queryPageIndexTypeInfo', queryPageIndexTypeInfo, TaskType.QUERY);
    let result: PageIndexTypeInfo[] | undefined =
      await this.doTask(taskInfo, tableName, conditions as Object) as PageIndexTypeInfo[];
    return result === undefined ? [] : result;
  }

  /**
   * 查询外屏应用分类信息
   *
   * @param tableName 表名
   * @returns 外屏应用分类信息
   */
  public async queryOuterAppCategorize(tableName: string): Promise<Map<string, string[]>> {
    const taskInfo: TaskInfo = new TaskInfo('queryOuterAppCategorize', queryOuterAppCategorize, TaskType.QUERY);
    let result: Map<string, string[]> | undefined =
      await this.doTask(taskInfo, tableName) as Map<string, string[]>;
    return result === undefined ? new Map<string, string[]>() : result;
  }

  /**
   * 查询卡片信息
   *
   * @param tableName 表名
   * @param conditions 条件
   * @returns 卡片信息列表
   */
  public async queryForm(tableName: string, conditions: Map<string, rdb.ValueType>): Promise<CardItemInfo[]> {
    const taskInfo: TaskInfo = new TaskInfo('queryForm', queryForm, TaskType.QUERY);
    let result: CardItemInfo[] | undefined =
      await this.doTask(taskInfo, tableName, conditions) as CardItemInfo[];
    return result === undefined ? [] : result;
  }

  /**
   * 查询上滑默认卡片信息
   *
   * @param tableName 表名
   * @param conditions 条件
   * @returns 上滑默认卡片信息列表
   */
  public async querySwiperForm(tableName: string, conditions?: Map<string, rdb.ValueType>): Promise<SwiperItemInfo[]> {
    const taskInfo: TaskInfo = new TaskInfo('querySwiperForm', querySwiperForm, TaskType.QUERY);
    let result: SwiperItemInfo[] | undefined =
      await this.doTask(taskInfo, tableName, conditions as Object) as SwiperItemInfo[];
    return result === undefined ? [] : result;
  }

  /**
   * 查询布局信息
   *
   * @param tableName 表名
   * @param conditions 条件
   * @returns 布局信息列表
   */
  public async queryGridLayoutInfo(tableName: string,
    conditions: Map<string, rdb.ValueType> | undefined, ctx?: SingleContext, isOrNotOneScreen?: boolean):
    Promise<GridLayoutItemInfo[]> {
    const taskInfo: TaskInfo = new TaskInfo('queryGridLayoutInfo', queryGridLayoutInfo, TaskType.QUERY);
    let result: GridLayoutItemInfo[] | undefined =
      await this.doTask(taskInfo, tableName,
        conditions as Object, ctx as Object, isOrNotOneScreen as Object) as GridLayoutItemInfo[];
    return result === undefined ? [] : result;
  }

  /**
   * 查询布局记录（不包含layoutInfo），包含桌面和dock
   *
   * @param tableName 表名
   * @param conditions 条件
   * @returns 布局信息列表
   */
  public async queryItemRecords(tableName: string,
    conditions: Map<string, rdb.ValueType>): Promise<GridLayoutItemInfo[]> {
    const taskInfo: TaskInfo = new TaskInfo('queryItemRecords', queryItemRecords, TaskType.QUERY);
    return await this.doTask(taskInfo, tableName, conditions) as GridLayoutItemInfo[];
  }

  /**
   * 查询布局信息，包括dock
   *
   * @param tableName 表名
   * @param conditions 条件
   * @returns 布局信息列表
   */
  public async queryAllGridLayoutInfo(tableName: string,
    conditions?: Map<string, rdb.ValueType>): Promise<GridLayoutItemInfo[]> {
    const taskInfo: TaskInfo = new TaskInfo('queryAllGridLayoutInfo', queryAllGridLayoutInfo, TaskType.QUERY);
    let result: GridLayoutItemInfo[] =
      await this.doTask(taskInfo, tableName, conditions as Object) as GridLayoutItemInfo[];
    return result === undefined ? [] : result;
  }

  /**
   * 查询一页布局信息
   *
   * @param tableName 表名
   * @param conditions 条件
   * @returns 布局信息列表
   */
  public async queryGridLayoutInfoByPage(tableName: string,
    conditions: Map<string, rdb.ValueType>): Promise<GridLayoutItemInfo[]> {
    const taskInfo: TaskInfo = new TaskInfo('queryGridLayoutInfo', queryGridLayoutInfo, TaskType.QUERY);
    let result: GridLayoutItemInfo[] =
      await this.doTask(taskInfo, tableName, conditions) as GridLayoutItemInfo[];
    return result === undefined ? [] : result;
  }

  /**
   * 查询布局元素是否存在
   *
   * @param tableName 表名
   * @param conditions 条件
   * @returns 是否存在
   */
  public async isElementExistInGridLayout(tableName: string, conditions: Map<string, rdb.ValueType>): Promise<boolean> {
    const taskInfo: TaskInfo = new TaskInfo('isExistInGridLayout', isExistInGridLayout, TaskType.QUERY);
    return await this.doTask(taskInfo, tableName, conditions) as boolean;
  }

  /**
   * 批量卡片信息
   *
   * @param tableName 表名
   * @param relationCards 卡片信息
   * @returns 是否成功
   */
  public async updateRelationFormInfoOfDb(tableName: string, relationCards: CardItemInfo[],
    sceneMsg: string = SceneMsgEnum.RDB_DEFAULT_UPDATE): Promise<boolean> {
    const taskInfo: TaskInfo = new TaskInfo('updateRelationFormInfoOfDb', updateRelationFormInfoOfDb, TaskType.UPDATE);
    return await this.doTask(taskInfo, tableName, relationCards, sceneMsg) as boolean;
  }

  /**
   * 批量删除卡片信息
   *
   * @param tableName 表名
   * @param deleteIds 删除卡片id
   * @returns 是否成功
   */
  public async deleteRelationFormInfoOfDb(tableName: string, deleteIds: string[],
    sceneMsg: string = SceneMsgEnum.RDB_DEFAULT_DELETE): Promise<boolean> {
    const taskInfo: TaskInfo = new TaskInfo('deleteRelationFormInfoOfDb', deleteRelationFormInfoOfDb, TaskType.DELETE);
    return await this.doTask(taskInfo, tableName, deleteIds, sceneMsg) as boolean;
  }

  /**
   * 批量删除布局信息
   *
   * @param tableName 表名
   * @param items 删除需要删除的布局信息
   * @returns 是否成功
   */
  public async deleteItemsByInfoIdAndContainer(tableName: string, deleteItems: GridLayoutItemInfo[],
    sceneMsg: string = SceneMsgEnum.RDB_DEFAULT_DELETE): Promise<boolean> {
    const taskInfo: TaskInfo = new TaskInfo('deleteItemsByInfoIdAndContainer', deleteItemsByInfoIdAndContainer, TaskType.DELETE);
    return await this.doTask(taskInfo, tableName, deleteItems, sceneMsg) as boolean;
  }

  /**
   * 更新下载信息
   *
   * @param appInfo：应用信息
   * @returns 数据库操作码。CommonConstants.INVALID_VALUE为失败
   */
  public async updateDownload(target: string, appInfo: DownloadInfoItem,
    sceneMsg: string = SceneMsgEnum.RDB_DEFAULT_UPDATE): Promise<number> {
    const taskInfo: TaskInfo = new TaskInfo('updateDownloadInfo', updateDownloadInfo, TaskType.UPDATE);
    let updates = <number> await this.doTask(taskInfo, target, appInfo, sceneMsg);
    if (updates > 0) {
      log.showWarn('appInstall updateDownloadInfo bundleName:%{public}s oldBundleName:%{public}s target:%{public}s resultRow:%{public}d',
        appInfo.bundleName, appInfo.oldBundleName, target, updates);
    } else {
      log.showError('appInstall updateDownloadInfo error! target:%{public}s appInfo:%{public}s',
        target, JSON.stringify(appInfo));
    }
    return updates;
  }

  public async queryNotInstalledApplication(tableName: string): Promise<string[]> {
    const taskInfo: TaskInfo = new TaskInfo('queryNotInstalledApplication', queryNotInstalledApplication, TaskType.QUERY);
    let result: string[] = await this.doTask(taskInfo, tableName) as string[];
    return result === undefined ? [] : result;
  }

  /**
   * 更新起始页范围内元素页数
   *
   * @param startPage 开始的页数
   * @param endPage 结束的页数
   * @param changeStep 改变步长
   * @returns true 更新成功
   */
  public async updateGridLayoutInfoPositionByPage(tableName: string, startPage: number, endPage: number,
    changeStep: number, sceneMsg: string = SceneMsgEnum.RDB_DEFAULT_DELETE): Promise<boolean> {

    const taskInfo: TaskInfo = new TaskInfo('updateGridLayoutPageByPage', updateGridLayoutPageByPage, TaskType.UPDATE);
    return await this.doTask(taskInfo, tableName, startPage, endPage, changeStep, sceneMsg) as boolean;
  }

  private async doTask(info: TaskInfo, ...args: unknown[]): Promise<unknown> {
    try {
      let context = GlobalContext.getContext();
      args.push(context);
      const dbTask = new taskPool.Task(info.name, info.func, ...args);
      return await this.executeTask(info, dbTask);
    } catch (e) {
      log.showError('doTask[%{public}s] name:[%{public}s] error %{public}d:%{public}s', info.func.name, info.name, e.code, e.message);
    }
    return undefined;
  }

  private async doExceptionTask(info: TaskInfo, ...args: Object[]): Promise<Object | undefined> {
    try {
      let context = GlobalContext.getContext();
      args.push(context);
      const dbTask = new taskPool.Task(info.name, info.func, ...args);
      return await this.executeTask(info, dbTask);
    } catch (e) {
      log.showError('doTask[%{public}s] name:[%{public}s] error %{public}d:%{public}s', info.func.name, info.name, e.code, e.message);
      throw e as Error;
    }
  }

  private async executeTask(info: TaskInfo, task: taskPool.Task): Promise<Object | undefined> {
    try {
      if (this.isStartingUp) {
        const isQuery: boolean = info.type === TaskType.QUERY;
        const runner: taskPool.SequenceRunner = isQuery ? this.readRunner : this.writeRunner;
        log.showWarn('execute task: %{public}s with runner, isQuery: %{public}s', info.name, isQuery);
        return await runner.execute(task);
      }
      log.showWarn('execute task: %{public}s', info.name);
      return await taskPool.execute(task);
    } catch (e) {
      log.showError('executeTask:[%{public}s] error %{public}d:%{public}s', info.name, e.code, e.message);
      throw e as Error;
    }
  }
}

/**
 * task任务信息
 */
export class TaskInfo {
  // task名称
  public name: string;
  // task具体执行方法
  public func: Function;
  // task类型
  public type: TaskType;

  constructor(name: string, func: Function, type: TaskType) {
    this.name = name;
    this.func = func;
    this.type = type;
  }
}

/**
 * task类型
 */
export enum TaskType {
  // 查询
  QUERY = 0,
  // 插入
  INSERT = 1,
  // 更新
  UPDATE = 2,
  // 删除
  DELETE = 3,
}

export const rdbTaskPool: RdbTaskPool = RdbTaskPool.getInstance();

async function insert(tableName: string, valuesBucket: rdb.ValuesBucket, sceneMsg: string,
  context: Context.BaseContext): Promise<number> {
  'use concurrent';
  let executeSql: string =
    `INSERT ${tableName} SET ${rdbStoreHelper.valuesBucketToStr(valuesBucket, RdbLogUtils.getPrintSets())}`;
  let res = await rdbStoreHelper.insert(tableName, valuesBucket, context, sceneMsg);
  rdbStoreHelper.printExecuteSql('insert', sceneMsg, executeSql, res);
  return res;
}

async function batchInsert(tableName: string, insertBucketList: Array<rdb.ValuesBucket>, sceneMsg: string,
  context: Context.BaseContext): Promise<number> {
  'use concurrent';
  return await rdbStoreHelper.batchInsert(tableName, insertBucketList, context, sceneMsg);
}

async function updateNewInstalledApp(tableName: string, gridlayoutInfo: GridLayoutItemInfo, sceneMsg: string,
  context: Context.BaseContext,): Promise<number> {
  'use concurrent';
  const predicates = new rdb.RdbPredicates(tableName);
  predicates.equalTo(GridLayoutInfoColumns.BUNDLE_NAME, gridlayoutInfo.bundleName)
    .equalTo(GridLayoutInfoColumns.APP_INDEX, gridlayoutInfo.appIndex)
    .equalTo(GridLayoutInfoColumns.TYPE_ID, CommonConstants.TYPE_APP);
  let valuesBucket: rdb.ValuesBucket = {
    [GridLayoutInfoEnums.MODULE_NAME]: gridlayoutInfo.moduleName,
    [GridLayoutInfoEnums.ABILITY_NAME]: gridlayoutInfo.abilityName,
    [GridLayoutInfoEnums.APP_ICON_ID]: gridlayoutInfo.appIconId,
    [GridLayoutInfoEnums.APP_LABEL_ID]: gridlayoutInfo.appLabelId,
    [GridLayoutInfoEnums.ICON_RESOURCE]: null,
    [GridLayoutInfoEnums.DOWNLOAD_PROGRESS]: null,
    [GridLayoutInfoEnums.APP_STATUS]: gridlayoutInfo.appStatus,
    [GridLayoutInfoEnums.INFO_NAME]: gridlayoutInfo.appName,
    [GridLayoutInfoEnums.INTENT]: gridlayoutInfo.intent
  };
  let executeSql: string = `UPDATE ${tableName} SET ${rdbStoreHelper.valuesBucketToStr(valuesBucket)}
  WHERE ${GridLayoutInfoColumns.BUNDLE_NAME}=${gridlayoutInfo.bundleName} AND ${GridLayoutInfoColumns.APP_INDEX}=${gridlayoutInfo.appIndex} AND  ${GridLayoutInfoColumns.TYPE_ID}=${CommonConstants.TYPE_APP}`;
  let res = await rdbStoreHelper.update(predicates, valuesBucket, context, sceneMsg, false, 0, tableName);
  rdbStoreHelper.printExecuteSql('updateNewInstalledApp', sceneMsg, executeSql, res);
  return res;
}

async function updateWithEqual(tableName: string, conditions: Map<string, rdb.ValueType>,
  valuesBucket: rdb.ValuesBucket, sceneMsg: string, context: Context.BaseContext): Promise<number> {
  'use concurrent';
  const predicates = new rdb.RdbPredicates(tableName);
  conditions?.forEach((value, key) => {
    predicates.and().equalTo(key, value);
  });
  let executeSql: string =
    `UPDATE ${tableName} SET ${rdbStoreHelper.valuesBucketToStr(valuesBucket)} WHERE ${rdbStoreHelper.conditionsToStr(conditions)}`;
  let res = await rdbStoreHelper.update(predicates, valuesBucket, context, sceneMsg, false, 0, tableName);
  rdbStoreHelper.printExecuteSql('updateWithEqual', sceneMsg, executeSql, res);
  return res;
}

async function updateWithPredicates(predicates: rdb.RdbPredicates,
  valuesBucket: rdb.ValuesBucket, sceneMsg: string, tableName: string, context: Context.BaseContext): Promise<number> {
  'use concurrent';
  const TAG = 'taskPool';
  const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
  log.showWarn('update by valuesBucket start');
  let num: number = await rdbStoreHelper.update(predicates, valuesBucket, context, sceneMsg, false, 0, tableName);
  log.showWarn('update by valuesBucket end, num: %{public}d', num);
  return num;
}

async function deleteWithEqual(tableName: string, conditions: Map<string, rdb.ValueType>, sceneMsg: string,
  context: Context.BaseContext): Promise<number> {
  'use concurrent';
  const predicates = new rdb.RdbPredicates(tableName);
  conditions?.forEach((value, key) => {
    predicates.and().equalTo(key, value);
  });
  let executeSql: string = `DELETE FROM ${tableName} WHERE ${rdbStoreHelper.conditionsToStr(conditions)}`;
  let res = await rdbStoreHelper.delete(predicates, context, sceneMsg, false, 0, tableName);
  rdbStoreHelper.printExecuteSql('deleteWithEqual', sceneMsg, executeSql, res);
  return res;
}

async function insertAppCenter(tableName: string, appGridlayoutInfo: AppGridItemInfo[],
  sceneMsg: string, context: Context.BaseContext): Promise<boolean> {
  'use concurrent';
  const TAG = 'taskPool';
  const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
  log.showInfo('insertAppCenter start');
  try {
    let rdbStore = rdbStoreHelper.getRdbStore();
    if (rdbStore === undefined) {
      await rdbStoreHelper.createRdbStore(context);
    }
    log.showInfo(`insertAppCenter, rdbStore is undefined: ${rdbStore === undefined}`);
    rdbStoreHelper.getRdbStore()?.beginTransaction();
    for (const item of appGridlayoutInfo) {
      let valuesBucket: rdb.ValuesBucket = AppGridItemInfo.toValuesBucketForAppCenter(item);
      let executeSql: string = `INSERT INTO ${tableName} SET ${rdbStoreHelper.valuesBucketToStr(valuesBucket)}`;
      let res = await rdbStoreHelper.insert(tableName, valuesBucket, context, sceneMsg);
      rdbStoreHelper.printExecuteSql('insertAppCenter', sceneMsg, executeSql, res);
    }
    rdbStoreHelper.getRdbStore()?.commit();
    log.showInfo('insertAppCenter success');
    return true;
  } catch (e) {
    rdbStoreHelper.getRdbStore()?.rollBack();
    log.showError('insertAppCenter error%{public}d:%{public}s', e?.code, e?.message);
  }
  log.showInfo('insertAppCenter end');
  return false;
}

async function insertGridLayoutInfo(tableName: string, gridlayoutInfo: GridLayoutItemInfo[], sceneMsg: string,
  screenId: number, context: Context.BaseContext): Promise<boolean> {
  'use concurrent';
  const TAG = 'taskPool';
  const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
  log.showInfo('insertGridLayoutInfo start');
  try {
    let rdbStore = rdbStoreHelper.getRdbStore();
    if (rdbStore === undefined) {
      await rdbStoreHelper.createRdbStore(context);
    }
    rdbStoreHelper.getRdbStore()?.beginTransaction();
    for (const item of gridlayoutInfo) {
      let gridLayoutDB = GridLayoutItemInfoDB.toGridLayoutItemInfoDB(item);
      gridLayoutDB.screenId = screenId;
      let valuesBucket: rdb.ValuesBucket = gridLayoutDB.toValuesBucket();
      let executeSql: string = `INSERT ${tableName} SET ${RdbLogUtils.genGridLayoutInfoLog(item)}`;
      let promise = await rdbStoreHelper.insert(tableName, valuesBucket, context);
      rdbStoreHelper.printExecuteSql('insertGridLayoutInfo', sceneMsg, executeSql, promise);
      if ((item.typeId === CommonConstants.TYPE_FOLDER || item.typeId === CommonConstants.TYPE_FORM_STACK) &&
        item.layoutInfo !== undefined && item.layoutInfo.length > 0) {
        log.showWarn(`insertGridLayoutInfo container:${promise} intent:${item.intent ?? ''}`);
        // 插入文件夹/卡片堆叠中的布局信息
        for (const layoutItems of item.layoutInfo) {
          await Promise.all(layoutItems.map(tempItem => {
            if (tempItem.typeId === CommonConstants.TYPE_ADD) {
              return undefined;
            }
            tempItem.container = promise;
            let gridLayoutDB = GridLayoutItemInfoDB.toGridLayoutItemInfoDB(tempItem);
            gridLayoutDB.screenId = screenId;
            let insertBuckets: rdb.ValuesBucket = gridLayoutDB.toValuesBucket();
            let executeInsertSql: string = `INSERT ${tableName} SET ${RdbLogUtils.genGridLayoutInfoLog(tempItem)}`;
            let res = rdbStoreHelper.insert(tableName, insertBuckets, context);
            rdbStoreHelper.printExecuteSql('insertGridLayoutInfo layoutItems', sceneMsg, executeInsertSql);
            return res;
          }));
        };
      }
    }
    rdbStoreHelper.getRdbStore()?.commit();
    log.showInfo('insertGridLayoutInfo success');
    return true;
  } catch (e) {
    rdbStoreHelper.getRdbStore()?.rollBack();
    log.showError('insertGridLayoutInfo error%{public}d:%{public}s', e.code, e.message);
  }
  log.showInfo('insertGridLayoutInfo end');
  return false;
}

async function insertLayoutInfoNotExist(tableName: string, item: GridLayoutItemInfo, sceneMsg: string,
  context: Context.BaseContext): Promise<number> {
  'use concurrent';
  const TAG = 'taskPool appInstall';
  const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
  log.showInfo('appInstall insertLayoutInfoNotExist start, keyName:%{public}s', item.keyName);
  let insertId = -1;
  let shortcutId = item.shortcutId ?? '';
  let rdbHelper: RdbStoreHelper = new RdbStoreHelper();
  try {
    let predicates = new rdb.RdbPredicates(tableName);
    predicates.equalTo(GridLayoutInfoColumns.BUNDLE_NAME, item.bundleName);
    predicates.equalTo(GridLayoutInfoColumns.SHORTCUT_ID, shortcutId);
    if (item.abilityName) {
      predicates.equalTo(GridLayoutInfoColumns.ABILITY_NAME, item.abilityName);
    }
    if (item.moduleName) {
      predicates.equalTo(GridLayoutInfoColumns.MODULE_NAME, item.moduleName);
    }
    if (!Number.isNaN(item.appIndex)) {
      predicates.equalTo(GridLayoutInfoColumns.APP_INDEX, item.appIndex ?? 0);
    }
    let isExist: boolean = await rdbHelper.isExistData(predicates);
    if (isExist) {
      log.showWarn('insertLayoutInfoNotExist already Exist. keyName:%{public}s', item.keyName);
      return insertId;
    }

    await rdbHelper.createRdbStore(context);
    let rdbStore: rdb.RdbStore = rdbHelper.getRdbStore();
    if (!rdbStore) {
      log.showError('updateDownloadInfo rdbStore error, rdbStore is null!');
      return insertId;
    }
    rdbStore?.beginTransaction();
    let gridLayoutDB = GridLayoutItemInfoDB.toGridLayoutItemInfoDB(item);
    let valuesBucket: rdb.ValuesBucket = gridLayoutDB.toValuesBucket();
    let executeSql: string = `INSERT ${tableName} SET ${rdbStoreHelper.valuesBucketToStr(valuesBucket)}`;
    insertId = await rdbHelper.insert(tableName, valuesBucket, context, sceneMsg);
    rdbStoreHelper.printExecuteSql('insertLayoutInfoNotExist', sceneMsg, executeSql, insertId);
    rdbStore?.commit();
  } catch (e) {
    rdbHelper.getRdbStore()?.rollBack();
    log.showError('insertLayoutInfoNotExist error%{public}d:%{public}s', e.code, e.message);
  } finally {
    log.showWarn('insertLayoutInfoNotExist end insertId:%{public}d', insertId);
    rdbHelper.release();
  }
  return insertId;
}

async function queryBadge(tableName: string, conditions: Map<string, rdb.ValueType> | undefined,
  context: Context.BaseContext): Promise<BadgeItemInfo[]> {
  'use concurrent';
  const TAG = 'taskPool';
  const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
  const predicates = new rdb.RdbPredicates(tableName);
  conditions?.forEach((value, key) => {
    predicates.and().equalTo(key, value);
  });
  const resultList: BadgeItemInfo[] = [];
  try {
    let resultSet = await rdbStoreHelper.query(predicates, [], context);
    while (resultSet && resultSet.goToNextRow()) {
      resultList.push(new BadgeItemInfo().fromResultSet(resultSet));
    }
    resultSet?.close();
  } catch (error) {
    log.showError('queryBadge error%{public}d:%{public}s', error.code, error.message);
  }
  return resultList;
}

async function queryPageIndexTypeInfo(
  tableName: string,
  conditions: Map<string, rdb.ValueType>,
  context: Context.BaseContext
): Promise<PageIndexTypeInfo[]> {
  'use concurrent';
  const TAG = 'taskPool';
  const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
  const predicates = new rdb.RdbPredicates(tableName);
  conditions?.forEach((value, key) => {
    predicates.and().equalTo(key, value);
  });
  const resultList: PageIndexTypeInfo[] = [];
  try {
    let resultSet = await rdbStoreHelper.query(predicates, [], context);
    while (resultSet && resultSet.goToNextRow()) {
      resultList.push(new PageIndexTypeInfo().fromResultSet(resultSet));
    }
    resultSet?.close();
  } catch (error) {
    log.showError('queryPageIndexTypeInfo error%{public}d:%{public}s', error.code, error.message);
  }
  return resultList;
}

async function queryOuterAppCategorize(tableName: string, context: Context.BaseContext): Promise<Map<string, string[]>> {
  'use concurrent';
  const TAG = 'taskPool';
  const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
  const predicates = new rdb.RdbPredicates(tableName);
  const resultList: Map<string, string[]> = new Map();
  let resultSet: rdb.ResultSet | undefined = undefined;
  try {
    resultSet = await rdbStoreHelper.query(predicates, [], context);
    while (resultSet && resultSet.goToNextRow()) {
      let bundleName: string = resultSet.getString(resultSet.getColumnIndex('bundle_name'));
      let category: string = resultSet.getString(resultSet.getColumnIndex('category'));
      if (!resultList.has(category)) {
        resultList.set(category, []);
      }
      resultList.get(category)?.push(bundleName);
    }
  } catch (error) {
    log.showError('queryOuterAppCategorize error%{public}d:%{public}s', error.code, error.message);
  } finally {
    if (resultSet) {
      resultSet.close();
    }
  }
  return resultList;
}

async function queryForm(tableName: string, conditions: Map<string, rdb.ValueType>, context: Context.BaseContext): Promise<CardItemInfo[]> {
  'use concurrent';
  const TAG = 'taskPool';
  const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
  const predicates = new rdb.RdbPredicates(tableName);
  conditions?.forEach((value, key) => {
    predicates.and().equalTo(key, value);
  });
  const resultList: CardItemInfo[] = [];
  try {
    let resultSet = await rdbStoreHelper.query(predicates, [], context);
    while (resultSet && resultSet.goToNextRow()) {
      resultList.push(new CardItemInfo().fromResultSet(resultSet));
    }
    resultSet?.close();
  } catch (error) {
    log.showError('queryForm error%{public}d:%{public}s', error.code, error.message);
  }
  log.showInfo(`queryForm length ${resultList.length}`);
  return resultList;
}

async function querySwiperForm(tableName: string, conditions: Map<string, rdb.ValueType> | undefined, context: Context.BaseContext): Promise<SwiperItemInfo[]> {
  'use concurrent';
  const TAG = 'taskPool';
  const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
  const predicates = new rdb.RdbPredicates(tableName);
  conditions?.forEach((value, key) => {
    predicates.and().equalTo(key, value);
  });
  const resultList: SwiperItemInfo[] = [];
  try {
    let resultSet = await rdbStoreHelper.query(predicates, [], context);
    while (resultSet && resultSet.goToNextRow()) {
      resultList.push(new SwiperItemInfo().fromResultSet(resultSet));
    }
    resultSet?.close();
  } catch (error) {
    log.showError('querySwiperForm error%{public}d:%{public}s', error.code, error.message);
  }
  log.showInfo(`querySwiperForm length ${resultList.length}`);
  return resultList;
}

async function queryFirstPageAndDockApplication(tableName: string, context: Context.BaseContext): Promise<GridLayoutItemInfo[]> {
  'use concurrent';
  const TAG = 'taskPool';
  const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
  log.showInfo('queryFirstPageAndDockApplication start');
  const predicates = new rdb.RdbPredicates(tableName);
  predicates.beginWrap()
    .equalTo(GridLayoutInfoColumns.PAGE_INDEX, 0)
    .and()
    .equalTo(GridLayoutInfoColumns.CONTAINER, CommonConstants.CONTAINER_DESKTOP)
    .endWrap()
    .or()
    .equalTo(GridLayoutInfoColumns.CONTAINER, CommonConstants.CONTAINER_SMARTDOCK );
  let resultList: GridLayoutItemInfo[] = [];
  try {
    let resultSet = await rdbStoreHelper.query(predicates, [], context);
    let item: GridLayoutItemInfoDB;
    while (resultSet && resultSet.goToNextRow()) {
      item = GridLayoutItemDbBuilder.fromResultSet(resultSet).buildGridLayoutItemDB();
      resultList.push(item.toGridLayoutItemInfo());
    }
    resultSet?.close();
  } catch (e) {
    log.showError('queryFirstPageAndDockApplication error%{public}d:%{public}s', e.code, e.message);
  }
  log.showInfo(`queryFirstPageAndDockApplication end ${resultList.length}`);
  return resultList;
}

async function queryItemRecords(tableName: string, conditions: Map<string, rdb.ValueType>,
  context: Context.BaseContext): Promise<GridLayoutItemInfo[]> {
  'use concurrent';
  const TAG = 'taskPool';
  const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
  log.showWarn('queryItemRecords start');
  const predicates = new rdb.RdbPredicates(tableName);
  conditions?.forEach((value, key) => predicates.and().equalTo(key, value));
  let resultList: GridLayoutItemInfo[] = [];
  try {
    let resultSet = await rdbStoreHelper.query(predicates, [], context);
    while (resultSet && resultSet.goToNextRow()) {
      let itemDb: GridLayoutItemInfoDB = GridLayoutItemDbBuilder.fromResultSet(resultSet).buildGridLayoutItemDB();
      let item: GridLayoutItemInfo = itemDb.toGridLayoutItemInfo();
      resultList.push(item);
    }
    resultSet?.close();
  } catch (e) {
    log.showError('queryItemRecords error: %{public}d %{public}s', e.code, e.message);
  }
  log.showWarn('queryItemRecords end, res: %{public}d', resultList.length);
  return resultList;
}

async function queryGridLayoutInfo(target: string,
  conditions: Map<string, rdb.ValueType>,
  ctx? : SingleContext, isOrNotOneScreen?: boolean, context?: Context.BaseContext):
  Promise<GridLayoutItemInfo[]> {
  'use concurrent';
  const TAG = 'taskPool';
  const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
  log.showWarn('queryGridLayoutInfo start');
  const predicates = new rdb.RdbPredicates(target);
  if (conditions?.size !== 0) {
    conditions?.forEach((value, key) => {
      predicates.and().equalTo(key, value);
    });
  }
  getConditions(isOrNotOneScreen, predicates, ctx);
  let resultList: GridLayoutItemInfo[] = [];
  try {
    let resultSet = await rdbStoreHelper.query(predicates, [], context);
    log.showWarn(`queryGridLayoutInfo rowCount ${resultSet?.rowCount}`);
    while (resultSet && resultSet.goToNextRow()) {
      let item: GridLayoutItemInfoDB = GridLayoutItemDbBuilder.fromResultSet(resultSet).buildGridLayoutItemDB();
      if (item.container === CommonConstants.CONTAINER_DESKTOP) {
        let gridLayoutInfo = item.toGridLayoutItemInfo();
        // 获取文件夹内的元素
        if (item.typeId === CommonConstants.TYPE_FOLDER || item.typeId === CommonConstants.TYPE_REGION_FOLDER) {
          let container: number = resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.ID));
          let tempArray: Array<GridLayoutItemInfo[]> = [];

          let predicatesFolder = new rdb.RdbPredicates(target);
          predicatesFolder.equalTo(GridLayoutInfoColumns.CONTAINER, container);
          let resultSetFolderItem = await rdbStoreHelper.query(predicatesFolder, [], context);
          let folderItem: GridLayoutItemInfo[] = [];
          while (resultSetFolderItem && resultSetFolderItem.goToNextRow()) {
            let itemDb: GridLayoutItemInfoDB = GridLayoutItemDbBuilder.fromResultSet(resultSetFolderItem).buildGridLayoutItemDB();
            folderItem.push(itemDb.toGridLayoutItemInfo());
          }
          // 按照页->行->列对文件夹中应用排序
          folderItem.sort((folderAppItem1, folderAppItem2): number => {
            if (folderAppItem1.page === undefined || folderAppItem2.page === undefined) {
              return 0;
            }
            if (folderAppItem1.page === folderAppItem2.page) {
              if (folderAppItem1.row === undefined || folderAppItem2.row === undefined ||
                folderAppItem1.column === undefined || folderAppItem2.column === undefined) {
                return 0;
              }
              if (folderAppItem1.row === folderAppItem2.row) {
                return folderAppItem1.column - folderAppItem2.column;
              }
              return folderAppItem1.row - folderAppItem2.row;
            }
            return folderAppItem1.page - folderAppItem2.page;
          });
          resultSetFolderItem?.close();
          tempArray.push(folderItem);
          gridLayoutInfo.layoutInfo = tempArray;
        } else if (item.typeId === CommonConstants.TYPE_FORM_STACK) {
          let tempArray: Array<GridLayoutItemInfo[]> = [];
          let tempItem: GridLayoutItemInfo[] = [];
          let container: number = resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.ID));
          log.showInfo(`folder GridLayoutInfoColumns.ID container:${container}`);
          let predicatesItem: rdb.RdbPredicates = new rdb.RdbPredicates(target);
          predicatesItem.equalTo(GridLayoutInfoColumns.CONTAINER, container);
          let resultSetItem: rdb.ResultSet | undefined = await rdbStoreHelper.query(predicatesItem, [], context);
          while (resultSetItem && resultSetItem.goToNextRow()) {
            let itemDb: GridLayoutItemInfoDB = GridLayoutItemDbBuilder.fromResultSet(resultSetItem).buildGridLayoutItemDB();
            tempItem.push(itemDb.toGridLayoutItemInfo());
          }
          resultSetItem?.close();
          if (item.intent) {
            FormCommonUtil.sortFormStack(item.intent, tempItem);
          }
          tempArray.push(tempItem);
          gridLayoutInfo.layoutInfo = tempArray;
        }
        log.showWarn(`queryGridLayoutInfo ${target} ${gridLayoutInfo.bundleName}, location ${gridLayoutInfo.container}_${gridLayoutInfo.page}_${gridLayoutInfo.column}_${gridLayoutInfo.row} in desktop, typeId ${gridLayoutInfo.typeId}, appIndex ${gridLayoutInfo.appIndex}`);
        resultList.push(gridLayoutInfo);
      } else {
        log.showInfo(`queryGridLayoutInfo ${target}, ${item.bundleName}, location ${item.container}_${item.page}_${item.column}_${item.row} not in desktop`);
      }
    }
    resultSet?.close();
  } catch (e) {
    log.showError('queryGridLayoutInfo error%{public}d:%{public}s', e.code, e.message);
  }
  log.showInfo(`queryGridLayoutInfo end ${resultList.length}`);
  return resultList;

  function getConditions(isOrNotOneScreen: boolean | undefined, predicates: rdb.RdbPredicates,
    ctx?: SingleContext): void {
    if (isOrNotOneScreen === undefined) {
      isOrNotOneScreen = true;
    }
    if (!isOrNotOneScreen) {
      if (ctx?.extendScreenId ?? 0 === 0) {
        predicates.and().beginWrap();
        predicates.and().equalTo(GridLayoutInfoColumns.SCREEN_ID, 0);
        predicates.and().or();
        predicates.and().isNull(GridLayoutInfoColumns.SCREEN_ID);
        predicates.and().endWrap();
      } else {
        predicates.and().equalTo(GridLayoutInfoColumns.SCREEN_ID, ctx?.extendScreenId);
      }
    }
  }
}

async function queryAppCenter(tableName: string,
  context: Context.BaseContext): Promise<AppGridItemInfo[]> {
  'use concurrent';
  const TAG = 'taskPool';
  const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
  log.showInfo('queryAppCenter start');
  const predicates = new rdb.RdbPredicates(tableName);
  let resultList: AppGridItemInfo[] = [];
  let resultSet: rdb.ResultSet | undefined;
  try {
    resultSet = await rdbStoreHelper.query(predicates, [], context);
    while (resultSet?.goToNextRow()) {
      let item: AppGridItemInfo | undefined = AppGridItemInfo.fromResultSet(resultSet);
      if (item) {
        resultList.push(item);
      } else {
        log.showInfo('queryAppCenter item undefined');
      }
    }
    resultSet?.close();
  } catch (e) {
    log.showError('queryAppCenter error%{public}d:%{public}s', e.code, e.message);
    resultSet?.close();
  }
  log.showInfo(`queryAppCenter end ${resultList.length}`);
  return resultList;
}

async function queryAllGridLayoutInfo(tableName: string, conditions: Map<string, rdb.ValueType> | undefined,
  context: Context.BaseContext): Promise<GridLayoutItemInfo[]> {
  'use concurrent';
  const TAG = 'taskPool';
  const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
  log.showWarn('queryAllGridLayoutInfo start');
  const predicates = new rdb.RdbPredicates(tableName);
  conditions?.forEach((value, key) => {
    predicates.and().equalTo(key, value);
  });
  let resultList: GridLayoutItemInfo[] = [];
  try {
    let resultSet = await rdbStoreHelper.query(predicates, [], context);
    while (resultSet && resultSet.goToNextRow()) {
      let item: GridLayoutItemInfoDB = GridLayoutItemDbBuilder.fromResultSet(resultSet).buildGridLayoutItemDB();

      let gridLayoutInfo = item.toGridLayoutItemInfo();
      // 获取文件夹内的元素
      if (item.typeId === CommonConstants.TYPE_FOLDER) {
        let folderItem: GridLayoutItemInfo[] = [];
        let tempArray: Array<GridLayoutItemInfo[]> = [];
        let container: number = resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.ID));

        let predicatesFolder = new rdb.RdbPredicates(tableName);
        predicatesFolder.equalTo(GridLayoutInfoColumns.CONTAINER, container);
        let resultSetFolderItem = await rdbStoreHelper.query(predicatesFolder, [], context);
        while (resultSetFolderItem && resultSetFolderItem.goToNextRow()) {
          let itemDb: GridLayoutItemInfoDB = GridLayoutItemDbBuilder.fromResultSet(resultSetFolderItem).buildGridLayoutItemDB();
          folderItem.push(itemDb.toGridLayoutItemInfo());
        }
        resultSetFolderItem?.close();
        tempArray.push(folderItem);
        gridLayoutInfo.layoutInfo = tempArray;
      }
      resultList.push(gridLayoutInfo);
    }
    resultSet?.close();
  } catch (e) {
    log.showError('queryAllGridLayoutInfo error%{public}d:%{public}s', e.code, e.message);
  }
  log.showWarn(`queryAllGridLayoutInfo end ${resultList.length}`);
  return resultList;
}

async function updateAppCenterItemPositions(tableName: string, appGridItemList: AppGridItemInfo[],
  sceneMsg: string, context: Context.BaseContext): Promise<boolean> {
  'use concurrent';
  const TAG = 'taskPool';
  const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
  log.showInfo('updateAppCenterItemPositions start');
  try {
    let rdbStore = rdbStoreHelper.getRdbStore();
    if (rdbStore === undefined) {
      await rdbStoreHelper.createRdbStore(context);
    }
    rdbStoreHelper.getRdbStore()?.beginTransaction();
    for (const gridItem of appGridItemList) {
      let predicates = new rdb.RdbPredicates(tableName);
      predicates.equalTo(GridLayoutInfoColumns.BUNDLE_NAME, gridItem.bundleName)
        .and().equalTo(GridLayoutInfoColumns.APP_INDEX, gridItem.appIndex ?? 0);

      let valuesBucket: rdb.ValuesBucket = {
        [GridLayoutInfoEnums.PAGE_INDEX]: gridItem.page,
        [GridLayoutInfoEnums.COLUMN]: gridItem.column,
        [GridLayoutInfoEnums.ROW]: gridItem.row,
        [GridLayoutInfoEnums.APP_STATUS]: gridItem.appStatus,
        [GridLayoutInfoEnums.MODULE_NAME]: gridItem.moduleName,
        [GridLayoutInfoEnums.ABILITY_NAME]: gridItem.abilityName,
        [GridLayoutInfoEnums.APP_INDEX]: gridItem.appIndex
      };
      let executeSql: string =
        `UPDATE ${tableName} SET ${rdbStoreHelper.valuesBucketToStr(valuesBucket)} WHERE ${GridLayoutInfoColumns.BUNDLE_NAME} ${gridItem.bundleName} AND ${GridLayoutInfoColumns.APP_INDEX}=${gridItem.appIndex ?? 0}`;
      let updateResult = await rdbStoreHelper.update(predicates, valuesBucket, context, sceneMsg, false, 0, tableName);
      rdbStoreHelper.printExecuteSql('updateAppCenterItemPositions', sceneMsg, executeSql, updateResult);
      if (updateResult === CommonConstants.INVALID_VALUE) {
        throw new Error('updateAppCenterItemPositions update error');
      }
    }
    rdbStoreHelper.getRdbStore()?.commit();
    log.showInfo('updateAppCenterItemPositions success');
    return true;
  } catch (e) {
    log.showError(`updateGridLayoutBatch error:${e?.message}`);
    rdbStoreHelper.getRdbStore()?.rollBack();
  }
  return false;
}

async function updateBatchGridLayoutWithMapReplaceGroup(updateReqGroup: UpdateGirdLayoutReq[][],
  sceneMsg: string, context: Context.BaseContext): Promise<boolean> {
  'use concurrent';
  const TAG = 'taskPool';
  const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
  log.showInfo('updateBatchGridLayoutWithMapReplaceGroup start, size: %{public}d', updateReqGroup.length);
  let rdbStore = rdbStoreHelper.getRdbStore();
  if (rdbStore === undefined) {
    await rdbStoreHelper.createRdbStore(context);
  }
  for (let updateReqList of updateReqGroup) {
    try {
      rdbStoreHelper.getRdbStore()?.beginTransaction();
      for (let oneUpdateReq of updateReqList) {
        let predicates = new rdb.RdbPredicates(oneUpdateReq.tableName);
        predicates.in(GridLayoutInfoColumns.ID, oneUpdateReq.ids);
        let valuesBucket = UpdateGirdLayoutReqUtil.toValuesBucket(oneUpdateReq.newGridLayoutInfo);
        let executeSql: string =
          `UPDATE ${oneUpdateReq.tableName} SET ${rdbStoreHelper.valuesBucketToStr(valuesBucket)} WHERE ${GridLayoutInfoColumns.ID} IN ${oneUpdateReq.ids.toString()}`;
        let res = await rdbStoreHelper.update(predicates, valuesBucket, context, sceneMsg, false, 0, oneUpdateReq.tableName);
        rdbStoreHelper.printExecuteSql('updateBatchGridLayoutWithMapReplaceGroup', sceneMsg, executeSql, res);
      }
      rdbStoreHelper.getRdbStore()?.commit();
      log.showInfo('updateBatchGridLayoutWithMapReplaceGroup success');
    } catch (e) {
      log.showError(`updateBatchGridLayoutWithMapReplaceGroup error = ${e?.name}, ${e?.code}, ${e?.message}`);
      rdbStoreHelper.getRdbStore()?.rollBack();
    }
  }
  return true;
}
async function batchInsertOrUpdateRecentLock(tableName: string, recentLockList: LockPreference[],
  sceneMsg: string, context: Context.BaseContext): Promise<boolean> {
  'use concurrent';
  try {
    let rdbStore = rdbStoreHelper.getRdbStore();
    if (rdbStore === undefined) {
      await rdbStoreHelper.createRdbStore(context);
    }
    rdbStoreHelper.getRdbStore()?.beginTransaction();
    for (let i = 0; i < recentLockList.length; i++) {
      let recentLockParam: LockPreference = recentLockList[i];
      let predicates = new rdb.RdbPredicates(tableName);
      predicates.equalTo(RecentLockInfoColumns.BUNDLE_NAME, recentLockParam.bundleName)
        .and().equalTo(RecentLockInfoColumns.ABILITY_NAME, recentLockParam.abilityName)
        .and().equalTo(RecentLockInfoColumns.MODULE_NAME, recentLockParam.moduleName)
        .and().equalTo(RecentLockInfoColumns.APP_INDEX, recentLockParam.appIndex)

      let isExist: boolean = await rdbStoreHelper.isExistData(predicates);
      let valuesBucket: rdb.ValuesBucket = RecentLockUtils.toValuesBucket(recentLockParam);
      if (isExist) {
        await rdbStoreHelper.update(predicates, valuesBucket, context, sceneMsg, false, 0, tableName);
        continue;
      }
      await rdbStoreHelper.insert(tableName, valuesBucket, context, sceneMsg);
    }
    rdbStoreHelper.getRdbStore()?.commit();
    console.info('batchInsertOrUpdateRecentLock end');
    return true;
  } catch (e) {
    console.error(`batchInsertOrUpdateRecentLock error: ${e?.code}, ${e?.message}`);
    rdbStoreHelper.getRdbStore()?.rollBack();
    return false;
  }
}

// async function batchInsertOrUpdateAppCatInfo(tableName: string, appCatInfoList: appInfoManager.AppCategoryInfo[],
//   sceneMsg: string, context: Context.BaseContext): Promise<boolean> {
//   'use concurrent';
//   const TAG = 'taskPool';
//   const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
//   log.showInfo(`batchInsertOrUpdateAppCatInfo start, size: ${appCatInfoList?.length}`);
//   try {
//     let rdbStore = rdbStoreHelper.getRdbStore();
//     if (rdbStore === undefined) {
//       await rdbStoreHelper.createRdbStore(context);
//     }
//     rdbStoreHelper.getRdbStore()?.beginTransaction();
//     for (let i = 0; i < appCatInfoList.length; i++) {
//       let appCatInfo: appInfoManager.AppCategoryInfo = appCatInfoList[i];
//       let predicates = new rdb.RdbPredicates(tableName);
//       predicates.equalTo(AppCategoryInfoColumns.BUNDLE_NAME, appCatInfo.bundleName);
//
//       let isExist: boolean = await rdbStoreHelper.isExistData(predicates);
//       let valuesBucket: rdb.ValuesBucket = AppCategoryUtils.toValuesBucket(appCatInfo);
//       if (isExist) {
//         await rdbStoreHelper.update(predicates, valuesBucket, context, sceneMsg, false, 0, tableName);
//         continue;
//       }
//       await rdbStoreHelper.insert(tableName, valuesBucket, context, sceneMsg);
//     }
//     rdbStoreHelper.getRdbStore()?.commit();
//     log.showInfo('batchInsertOrUpdateAppCatInfo end');
//     return true;
//   } catch (e) {
//     log.showError(`batchInsertOrUpdateAppCatInfo error: ${e?.code}, ${e?.message}`);
//     rdbStoreHelper.getRdbStore()?.rollBack();
//     return false;
//   }
// }

// 批量更新 加桌上限
async function batchUpdateLayoutInfoShortcutLimit(tableName: string, gridInfos: GridLayoutItemInfo[],
  sceneMsg: string, context: Context.BaseContext): Promise<boolean> {
  'use concurrent';
  const TAG = 'taskPool';
  const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
  log.showInfo(`batchUpdateLayoutInfoShortcutLimit start, size: ${gridInfos.length}`);
  let rdbStore = rdbStoreHelper.getRdbStore();
  if (rdbStore === undefined) {
    await rdbStoreHelper.createRdbStore(context);
  }
  try {
    rdbStoreHelper.getRdbStore()?.beginTransaction();
    for (let limitInfo of gridInfos) {
      let predicates = new rdb.RdbPredicates(tableName);
      predicates.equalTo(GridLayoutInfoColumns.BUNDLE_NAME, limitInfo.bundleName).and().equalTo(GridLayoutInfoColumns.APP_INDEX, limitInfo.appIndex);
      const valueBucket: rdb.ValuesBucket = {
        [GridLayoutInfoEnums.INTENT]: limitInfo.intent
      };
      let executeSql: string =
        `UPDATE ${tableName} SET ${rdbStoreHelper.valuesBucketToStr(valueBucket)} WHERE ${GridLayoutInfoColumns.BUNDLE_NAME}=${limitInfo.bundleName} AND ${GridLayoutInfoColumns.APP_INDEX}=${limitInfo.appIndex}`;
      let res = await rdbStoreHelper.update(predicates, valueBucket, context, sceneMsg, false, 0, tableName);
      rdbStoreHelper.printExecuteSql('batchUpdateLayoutInfoShortcutLimit', sceneMsg, executeSql, res);
    }
    rdbStoreHelper.getRdbStore()?.commit();
    log.showInfo('batchUpdateLayoutInfoShortcutLimit success');
  } catch (e) {
    log.showError(`batchUpdateLayoutInfoShortcutLimit error = ${e?.name}, ${e?.code}, ${e?.message}`);
    rdbStoreHelper.getRdbStore()?.rollBack();
  }
  return true;
}

// async function queryAppCatInfo(tableName: string, conditions: Map<string, rdb.ValueType>, context: Context.BaseContext):
//   Promise<appInfoManager.AppCategoryInfo[]> {
//   'use concurrent';
//   const TAG = 'taskPool';
//   const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
//   log.showInfo('queryAppCatInfo start');
//   const predicates = new rdb.RdbPredicates(tableName);
//   conditions?.forEach((value, key) => {
//     predicates.and().equalTo(key, value);
//   });
//   const resultList: appInfoManager.AppCategoryInfo[] = [];
//   try {
//     let resultSet = await rdbStoreHelper.query(predicates, [], context);
//     while (resultSet && resultSet.goToNextRow()) {
//       let categoryInfo = AppCategoryUtils.fromResultSet(resultSet);
//       if (categoryInfo) {
//         resultList.push(categoryInfo);
//       }
//     }
//     resultSet?.close();
//   } catch (e) {
//     log.showError(`queryAppCatInfo error: ${e?.code}, ${e?.message}`);
//   }
//   log.showInfo(`queryAppCatInfo length: ${resultList.length}`);
//   return resultList;
// }

async function queryRecentLock(target: string, conditions: Map<string, rdb.ValueType>, context: Context.BaseContext):
  Promise<LockPreference[]> {
  'use concurrent';
  console.info(`queryRecentList start ${target}`);
  const predicates = new rdb.RdbPredicates(target);
  conditions?.forEach((value, key) => {
    predicates.and().equalTo(key, value);
  });
  const resultList: LockPreference[] = [];
  try {
    let resultSet = await rdbStoreHelper.query(predicates, [], context);
    while (resultSet && resultSet.goToNextRow()) {
      let lockPreference = RecentLockUtils.fromResultSet(resultSet);
      if (lockPreference) {
        resultList.push(lockPreference);
      }
    }
    resultSet?.close();
  } catch (e) {
    console.error(`queryRecentLock error: ${e?.code}, ${e?.message}`);
  }
  console.log(`queryRecentLock length: ${resultList.length}`);
  return resultList;
}

// 暂时只更新系统字段
async function updateAppCenterItemSys(tableName: string, appGridItemList: AppGridItemInfo[],
  sceneMsg: string, context: Context.BaseContext): Promise<boolean> {
  'use concurrent';
  const TAG = 'taskPool';
  const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
  log.showInfo('updateAppCenterItemPositions start');
  try {
    let rdbStore = rdbStoreHelper.getRdbStore();
    if (rdbStore === undefined) {
      await rdbStoreHelper.createRdbStore(context);
    }
    rdbStoreHelper.getRdbStore()?.beginTransaction();
    for (const gridItem of appGridItemList) {
      let predicates = new rdb.RdbPredicates(tableName);
      predicates.equalTo(GridLayoutInfoColumns.BUNDLE_NAME, gridItem.bundleName)
        .and().equalTo(GridLayoutInfoColumns.APP_INDEX, gridItem.appIndex ?? 0);

      let valuesBucket: rdb.ValuesBucket = {
        [GridLayoutInfoEnums.MODULE_NAME]: gridItem.moduleName,
        [GridLayoutInfoEnums.ABILITY_NAME]: gridItem.abilityName,
      };
      let executeSql: string =
        `UPDATE ${tableName} SET ${rdbStoreHelper.valuesBucketToStr(valuesBucket)} WHERE ${GridLayoutInfoColumns.BUNDLE_NAME} = ${gridItem.bundleName} AND ${GridLayoutInfoColumns.APP_INDEX} = ${gridItem.appIndex ?? 0}`;
      let updateResult = await rdbStoreHelper.update(predicates, valuesBucket, context, sceneMsg, false, 0, tableName);
      rdbStoreHelper.printExecuteSql('updateAppCenterItemSys', sceneMsg, executeSql, updateResult);
      if (updateResult === CommonConstants.INVALID_VALUE) {
        throw new Error('updateAppCenterItemPositions update error');
      }
    }
    rdbStoreHelper.getRdbStore()?.commit();
    log.showInfo('updateAppCenterItemPositions success');
    return true;
  } catch (e) {
    log.showError(`updateGridLayoutBatch error:${e?.message}`);
    rdbStoreHelper.getRdbStore()?.rollBack();
  }
  return false;
}

async function updateGridLayoutPositionBatch(tableName: string, gridItemList: GridLayoutItemInfo[],
  sceneMsg: string, context: Context.BaseContext): Promise<boolean> {
  'use concurrent';
  const TAG = 'taskPool';
  const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
  log.showWarn('updateGridLayoutPositionBatch start, size: %{public}d', gridItemList.length);
  try {
    let rdbStore = rdbStoreHelper.getRdbStore();
    if (rdbStore === undefined) {
      await rdbStoreHelper.createRdbStore(context);
    }
    rdbStoreHelper.getRdbStore()?.beginTransaction();
    for (const gridItem of gridItemList) {
      let predicates = new rdb.RdbPredicates(tableName);
      predicates.equalTo(GridLayoutInfoColumns.TYPE_ID, gridItem.typeId);
      let whereSql: string = `${GridLayoutInfoColumns.TYPE_ID}=${gridItem.typeId} `;
      if (gridItem.typeId === CommonConstants.TYPE_APP || gridItem.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
        predicates.equalTo(GridLayoutInfoColumns.BUNDLE_NAME, gridItem.bundleName)
          .and().equalTo(GridLayoutInfoColumns.APP_INDEX, gridItem.appIndex ?? 0)
          .and().equalTo(GridLayoutInfoColumns.SHORTCUT_ID, gridItem.shortcutId ?? '');
        whereSql += (` AND ${GridLayoutInfoColumns.BUNDLE_NAME}=${gridItem.bundleName} AND ${GridLayoutInfoColumns.APP_INDEX}=${gridItem.appIndex ?? 0}
        AND ${GridLayoutInfoColumns.SHORTCUT_ID}=${gridItem.shortcutId ?? ''}`);
      } else if (gridItem.typeId === CommonConstants.TYPE_FOLDER) {
        predicates.equalTo(GridLayoutInfoColumns.INFO_ID, gridItem.folderId);
        whereSql += (` AND ${GridLayoutInfoColumns.INFO_ID}=${gridItem.folderId}`);
      } else if (gridItem.typeId === CommonConstants.TYPE_FORM_STACK) {
        predicates.equalTo(GridLayoutInfoColumns.INFO_ID, gridItem.formStackId);
        whereSql += (` AND ${GridLayoutInfoColumns.INFO_ID}=${gridItem.formStackId}`);
      } else if (gridItem.typeId === CommonConstants.TYPE_FILE_FOLDER) {
        predicates.equalTo(GridLayoutInfoColumns.FILE_INO, gridItem.ino);
        whereSql += (` AND ${GridLayoutInfoColumns.FILE_INO}=${gridItem.ino}`);
      } else {
        predicates.equalTo(GridLayoutInfoColumns.BUNDLE_NAME, gridItem.bundleName)
          .and().equalTo(GridLayoutInfoColumns.MODULE_NAME, gridItem.moduleName)
          .and().equalTo(GridLayoutInfoColumns.ABILITY_NAME, gridItem.abilityName);
        whereSql += (` AND ${GridLayoutInfoColumns.BUNDLE_NAME}=${gridItem.bundleName} AND ${GridLayoutInfoColumns.MODULE_NAME}=${gridItem.moduleName}
        AND ${GridLayoutInfoColumns.ABILITY_NAME}=${gridItem.abilityName}`);
      }
      if (gridItem.typeId === CommonConstants.TYPE_CARD) {
        predicates.and().equalTo(GridLayoutInfoColumns.INFO_ID, gridItem.cardId);
        whereSql += (` AND ${GridLayoutInfoColumns.INFO_ID}=${gridItem.cardId}`);
      }

      let valuesBucket: rdb.ValuesBucket = {
        [GridLayoutInfoEnums.PAGE_INDEX]: gridItem.page,
        [GridLayoutInfoEnums.LANDSCAPE_PAGE_INDEX]: gridItem.page,
        [GridLayoutInfoEnums.PORTRAIT_PAGE_INDEX]: gridItem.page,
        [GridLayoutInfoEnums.COLUMN]: gridItem.column,
        [GridLayoutInfoEnums.ROW]: gridItem.row,
        [GridLayoutInfoEnums.PORTRAIT_COLUMN]: gridItem.portraitColumn,
        [GridLayoutInfoEnums.PORTRAIT_ROW]: gridItem.portraitRow,
        [GridLayoutInfoEnums.LANDSCAPE_COLUMN]: gridItem.landscapeColumn,
        [GridLayoutInfoEnums.LANDSCAPE_ROW]: gridItem.landscapeRow
      };
      let executeSql: string = `UPDATE ${tableName} SET ${rdbStoreHelper.valuesBucketToStr(valuesBucket)} WHERE ${whereSql}`;
      let updateResult = await rdbStoreHelper.update(predicates, valuesBucket, context, sceneMsg, false, 0, tableName);
      rdbStoreHelper.printExecuteSql('updateGridLayoutPositionBatch', sceneMsg, executeSql, updateResult);
      if (updateResult === CommonConstants.INVALID_VALUE) {
        throw new Error('update error');
      }
    }
    rdbStoreHelper.getRdbStore()?.commit();
    log.showWarn('updateGridLayoutBatch success');
    return true;
  } catch (e) {
    log.showError('updateGridLayoutBatch error%{public}d:%{public}s', e.code, e.message);
    rdbStoreHelper.getRdbStore()?.rollBack();
  }
  return false;
}

async function updateGridLayoutPageByPage(tableName: string, startPage: number, endPage: number, changeStep: number,
  sceneMsg: string, context: Context.BaseContext): Promise<boolean> {
  'use concurrent';
  const TAG = 'taskPool';
  const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
  log.showInfo('updateGridLayoutPositionByPage start startPage %{public}d endPage %{public}d changeStep %{public}d',
    startPage, endPage, changeStep);
  if (changeStep <= 0) {
    return false;
  }
  try {
    let rdbStore = rdbStoreHelper.getRdbStore();
    if (rdbStore === undefined) {
      await rdbStoreHelper.createRdbStore(context);
    }
    rdbStoreHelper.getRdbStore()?.beginTransaction();
    for (let page = endPage; page >= startPage; page--) {
      let predicates = new rdb.RdbPredicates(tableName);
      predicates.equalTo(GridLayoutInfoColumns.PAGE_INDEX, page)
        .and().equalTo(GridLayoutInfoColumns.CONTAINER, CommonConstants.CONTAINER_DESKTOP);
      let valuesBucket: rdb.ValuesBucket = {
        [GridLayoutInfoEnums.PAGE_INDEX]: page + changeStep,
        [GridLayoutInfoEnums.LANDSCAPE_PAGE_INDEX]: page + changeStep,
        [GridLayoutInfoEnums.PORTRAIT_PAGE_INDEX]: page + changeStep
      };
      let executeSql: string =
        `UPDATE ${tableName} SET ${rdbStoreHelper.valuesBucketToStr(valuesBucket)} WHERE ${GridLayoutInfoColumns.PAGE_INDEX}=${page} AND ${GridLayoutInfoColumns.CONTAINER}=${CommonConstants.CONTAINER_DESKTOP}`;
      let updateResult: number =
        await rdbStoreHelper.update(predicates, valuesBucket, context, sceneMsg, false, 0, tableName);
      rdbStoreHelper.printExecuteSql('updateGridLayoutPageByPage', sceneMsg, executeSql, updateResult);
      if (updateResult === CommonConstants.INVALID_VALUE) {
        throw new Error('update error');
      }
      log.showInfo('addPage success num %{public}d', updateResult);
    }
    rdbStoreHelper.getRdbStore()?.commit();
    log.showInfo('updateGridLayoutPositionByPage success');
    return true;
  } catch (e) {
    log.showError('updateGridLayoutPositionByPage error%{public}d:%{public}s', e.code, e.message);
    rdbStoreHelper.getRdbStore()?.rollBack();
  }
  return false;
}

/**
 * 新增smartDock
 *
 * @param dockInfoList Dock列表
 * @returns true:新增成功;false:新增失败
 */
async function insertIntoSmartDock(dockInfoList: DockItemInfo[], tableName: string, sceneMsg: string,
  context: Context.BaseContext): Promise<boolean> {
  'use concurrent';
  const TAG = 'taskPool';
  const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
  log.showWarn('insertIntoSmartDock start, size: %{public}d', dockInfoList?.length);
  try {
    let rdbStore = rdbStoreHelper.getRdbStore();
    if (rdbStore === undefined) {
      await rdbStoreHelper.createRdbStore(context);
    }
    rdbStoreHelper.getRdbStore()?.beginTransaction();
    for (let i = 0; i < dockInfoList.length; i++) {
      let item: DockItemInfo = dockInfoList[i];
      let predicates = new rdb.RdbPredicates(tableName);
      predicates.equalTo(GridLayoutInfoColumns.BUNDLE_NAME, item.bundleName);
      let whereSql: string = `${GridLayoutInfoColumns.BUNDLE_NAME}=${item.bundleName}`;
      if (item.itemType !== CommonConstants.TYPE_FOLDER) {
        predicates.and().equalTo(GridLayoutInfoColumns.APP_INDEX, item.appIndex ?? 0)
          .and().equalTo(GridLayoutInfoColumns.SHORTCUT_ID, item.shortcutId ?? '')
          .and().equalTo(GridLayoutInfoColumns.TYPE_ID, item.itemType ? item.itemType : item.typeId);
        whereSql += (` AND ${GridLayoutInfoColumns.APP_INDEX}=${item.appIndex ?? 0}
                      AND ${GridLayoutInfoColumns.SHORTCUT_ID}=${item.shortcutId ?? ''}
                      AND ${GridLayoutInfoColumns.TYPE_ID}=${item.itemType ? item.itemType : item.typeId}`);
        // PC的回收站、应用中心等包名相同, 且Dock栏与桌面图标可同时存在
        if (DeviceHelper.isPC()) {
          predicates.and().equalTo(GridLayoutInfoColumns.ABILITY_NAME, item.abilityName);
          predicates.and().equalTo(GridLayoutInfoColumns.CONTAINER, CommonConstants.CONTAINER_SMARTDOCK);
          whereSql += (` AND ${GridLayoutInfoColumns.ABILITY_NAME}=${item.abilityName} AND ${GridLayoutInfoColumns.CONTAINER}=${CommonConstants.CONTAINER_SMARTDOCK}`);
        }
      }

      let isExist: boolean = await rdbStoreHelper.isExistData(predicates);
      if (isExist) {
        let valuesBucket: rdb.ValuesBucket = {
          [GridLayoutInfoEnums.BUNDLE_NAME]: item.bundleName,
          [GridLayoutInfoEnums.MODULE_NAME]: item.moduleName,
          [GridLayoutInfoEnums.ABILITY_NAME]: item.abilityName,
          [GridLayoutInfoEnums.APP_ICON_ID]: item.appIconId,
          [GridLayoutInfoEnums.APP_LABEL_ID]: item.appLabelId,
          [GridLayoutInfoEnums.INFO_NAME]: item.appName,
          [GridLayoutInfoEnums.ICON_RESOURCE]: item.iconResource,
          [GridLayoutInfoEnums.USER_ID]: 100,
          [GridLayoutInfoEnums.ROW]: 0,
          [GridLayoutInfoEnums.COLUMN]: i,
          [GridLayoutInfoEnums.CONTAINER]: CommonConstants.CONTAINER_SMARTDOCK,
          [GridLayoutInfoEnums.APP_STATUS]: item.appStatus,
          [GridLayoutInfoEnums.APP_INDEX]: item.appIndex,
          [GridLayoutInfoEnums.SHORTCUT_ID]: item.shortcutId,
          [GridLayoutInfoEnums.SCREEN_ID]: 0,
        };
        if (item.intent) {
          valuesBucket[GridLayoutInfoColumns.INTENT] = item.intent;
        }
        log.showWarn('update to dock bundleName: %{public}s, type: %{public}d', item.bundleName, item.itemType);
        let updateExecuteSql: string = `UPDATE ${tableName} SET ${rdbStoreHelper.valuesBucketToStr(valuesBucket)} WHERE ${whereSql}`;
        let updateRes = await rdbStoreHelper.update(predicates, valuesBucket, context, sceneMsg, false, 0, tableName);
        rdbStoreHelper.printExecuteSql('insertIntoSmartDock update', sceneMsg, updateExecuteSql, updateRes);
        continue;
      }
      let valuesBucket: rdb.ValuesBucket = DockItemInfo.toValuesBucket(item);
      valuesBucket[GridLayoutInfoColumns.COLUMN] = i;
      valuesBucket[GridLayoutInfoColumns.CONTAINER] = CommonConstants.CONTAINER_SMARTDOCK;
      if (item.intent) {
        valuesBucket[GridLayoutInfoColumns.INTENT] = item.intent;
      }
      log.showWarn('insert to dock bundleName: %{public}s, type: %{public}d', item.bundleName, item.itemType);
      let insertExecuteSql: string = `INSERT ${tableName} SET ${rdbStoreHelper.valuesBucketToStr(valuesBucket)}`;
      let insertRes = await rdbStoreHelper.insert(tableName, valuesBucket, context, sceneMsg);
      rdbStoreHelper.printExecuteSql('insertIntoSmartDock insert', sceneMsg, insertExecuteSql, insertRes);
    }
    rdbStoreHelper.getRdbStore()?.commit();
    log.showWarn('insertIntoSmartdock end');
    return true;
  } catch (e) {
    log.showError(`insertIntoSmartdock error:${JSON.stringify(e)}`);
    rdbStoreHelper.getRdbStore()?.rollBack();
    return false;
  }
}

/**
 * 新增dock的最近任务区
 *
 * @param dockInfoList Dock列表
 * @returns true:新增成功;false:新增失败
 */
async function insertIntoRecentDock(recentDockList: DockItemInfo[], tableName: string, sceneMsg: string,
  context: Context.BaseContext): Promise<boolean> {
  'use concurrent';
  const TAG = 'taskPool';
  const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
  try {
    let rdbStore = rdbStoreHelper.getRdbStore();
    if (rdbStore === undefined) {
      await rdbStoreHelper.createRdbStore(context);
    }
    rdbStoreHelper.getRdbStore()?.beginTransaction();
    for (let i = 0; i < recentDockList.length; i++) {
      let item: DockItemInfo = recentDockList[i];
      let valuesBucket: rdb.ValuesBucket = {
        [GridLayoutInfoEnums.BUNDLE_NAME]: item.bundleName,
        [GridLayoutInfoEnums.MODULE_NAME]: item.moduleName,
        [GridLayoutInfoEnums.ABILITY_NAME]: item.abilityName,
        [GridLayoutInfoEnums.APP_ICON_ID]: item.appIconId,
        [GridLayoutInfoEnums.APP_LABEL_ID]: item.appLabelId,
        [GridLayoutInfoEnums.APP_INDEX]: item.appIndex ?? 0,
        [GridLayoutInfoEnums.USER_ID]: 100,
        [GridLayoutInfoEnums.COLUMN]: i
      };
      let predicates = new rdb.RdbPredicates(tableName);
      predicates.equalTo(RecentDockInfoColumns.BUNDLE_NAME, item.bundleName)
        .and().equalTo(RecentDockInfoColumns.APP_INDEX, item.appIndex ?? 0);
      let resultSet = await rdbStoreHelper.query(predicates, [], context);
      if (resultSet && resultSet.goToNextRow()) {
        let updateExecuteSql: string =
          `UPDATE ${tableName} SET ${rdbStoreHelper.valuesBucketToStr(valuesBucket)} WHERE ${RecentDockInfoColumns.BUNDLE_NAME}=${item.bundleName}
          AND ${RecentDockInfoColumns.APP_INDEX}=${item.appIndex ?? 0}`;
        let result = await rdbStoreHelper.update(predicates, valuesBucket, context, sceneMsg, false, 0, tableName);
        rdbStoreHelper.printExecuteSql('insertIntoRecentDock update', sceneMsg, updateExecuteSql, result);
      } else {
        let insertExecuteSql: string = `UPDATE ${tableName} SET ${rdbStoreHelper.valuesBucketToStr(valuesBucket)}`;
        let result = await rdbStoreHelper.insert(tableName, valuesBucket, context, sceneMsg);
        rdbStoreHelper.printExecuteSql('insertIntoRecentDock insert', sceneMsg, insertExecuteSql, result);
      }
      resultSet?.close();
    }
    rdbStoreHelper.getRdbStore()?.commit();
    log.showInfo('insertIntoRecentDock success');
    return true;
  } catch (e) {
    log.showInfo(`insertIntoRecentDock error:${JSON.stringify(e)}`);
    rdbStoreHelper.getRdbStore()?.rollBack();
    return false;
  }
}

/**
 * 新增dock的最近任务区
 *
 * @param visibleCount 可见数量
 * @returns true:新增成功;false:新增失败
 */
async function insertIntoRecentDockInfo(visibleCount: number, tableName: string, sceneMsg: string,
  context: Context.BaseContext): Promise<boolean> {
  'use concurrent';
  const TAG = 'taskPool';
  const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
  try {
    let rdbStore = rdbStoreHelper.getRdbStore();
    if (rdbStore === undefined) {
      await rdbStoreHelper.createRdbStore(context);
    }
    rdbStoreHelper.getRdbStore()?.beginTransaction();
    let valuesBucket: rdb.ValuesBucket = {
      [RecentDockLayoutInfoEnums.VISIBLE_COUNT]: visibleCount,
    };
    let predicates = new rdb.RdbPredicates(tableName);
    let resultSet = await rdbStoreHelper.query(predicates, [], context);
    if (resultSet && resultSet.goToNextRow()) {
      let updateExecuteSql: string = `UPDATE ${tableName} SET ${rdbStoreHelper.valuesBucketToStr(valuesBucket)}`;
      let result = await rdbStoreHelper.update(predicates, valuesBucket, context, sceneMsg, false, 0, tableName);
      rdbStoreHelper.printExecuteSql('insertIntoRecentDockInfo update', sceneMsg, updateExecuteSql, result);
    } else {
      let insertExecuteSql: string = `INSERT ${tableName} SET ${rdbStoreHelper.valuesBucketToStr(valuesBucket)}`;
      let result = await rdbStoreHelper.insert(tableName, valuesBucket, context, sceneMsg);
      rdbStoreHelper.printExecuteSql('insertIntoRecentDockInfo insert', sceneMsg, insertExecuteSql, result);
    }
    resultSet?.close();
    rdbStoreHelper.getRdbStore()?.commit();
    log.showInfo('insertIntoRecentDockInfo success');
    return true;
  } catch (e) {
    log.showInfo(`insertIntoRecentDockInfo error:${JSON.stringify(e)}`);
    rdbStoreHelper.getRdbStore()?.rollBack();
    return false;
  }
}


/**
 * 查询smartDock元素，container = -101
 *
 * @returns smartDock元素列表
 */
async function querySmartDock(tableName: string, context: Context.BaseContext): Promise<DockItemInfo[]> {
  'use concurrent';
  const TAG = 'taskPool';
  const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
  const resultList: DockItemInfo[] = [];
  log.showWarn('querySmartDock');
  try {
    let predicates = new rdb.RdbPredicates(tableName);
    predicates.equalTo(GridLayoutInfoColumns.CONTAINER, CommonConstants.CONTAINER_SMARTDOCK);
    // dock按照列升序查询
    predicates.orderByAsc(GridLayoutInfoColumns.COLUMN);
    let keyNameSet: Set<string> = new Set<string>();
    let resultSet: rdb.ResultSet | undefined = await rdbStoreHelper.query(predicates, [], context);
    while (resultSet && resultSet.goToNextRow()) {
      const itemInfo: DockItemInfo = new DockItemInfo();
      itemInfo.itemType = resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.TYPE_ID));
      itemInfo.editable = false; // 临时
      itemInfo.appId = resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.INFO_ID));
      itemInfo.appName = resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.INFO_NAME));
      itemInfo.bundleName = resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.BUNDLE_NAME));
      itemInfo.abilityName = resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.ABILITY_NAME));
      itemInfo.moduleName = resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.MODULE_NAME));
      itemInfo.appIndex = resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.APP_INDEX));
      itemInfo.iconId = resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.ICON_RESOURCE));
      itemInfo.appIconId = resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.APP_ICON_ID));
      itemInfo.appLabelId = resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.APP_LABEL_ID));
      itemInfo.typeId = resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.TYPE_ID));
      itemInfo.shortcutId = resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.SHORTCUT_ID));
      itemInfo.applicationLabelId = itemInfo.appLabelId;
      itemInfo.applicationName = itemInfo.appName;
      itemInfo.visible = true;
      itemInfo.appStatus = resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.APP_STATUS));
      itemInfo.iconResource = resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.ICON_RESOURCE));
      itemInfo.downloadProgress = resultSet.getDouble(resultSet.getColumnIndex(GridLayoutInfoColumns.DOWNLOAD_PROGRESS));
      itemInfo.callerName = resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.CALLER_NAME));
      itemInfo.intent = resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.INTENT));
      itemInfo.container = CommonConstants.CONTAINER_SMARTDOCK;
      itemInfo.id = resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.ID));
      // 获取小文件夹内的元素
      if (itemInfo.itemType === CommonConstants.TYPE_FOLDER) {
        itemInfo.keyName = `${itemInfo.bundleName}${itemInfo.abilityName}${itemInfo.moduleName}`;
        itemInfo.extend1 = resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.EXTEND1));
        let tempArray: Array<GridLayoutItemInfo[]> = [];
        let folderItem: GridLayoutItemInfo[] = [];
        let container: number = resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.ID));
        let predicatesFolder = new rdb.RdbPredicates(tableName);
        predicatesFolder.equalTo(GridLayoutInfoColumns.CONTAINER, container);
        let resultSetFolderItem = await rdbStoreHelper.query(predicatesFolder, [], context);
        while (resultSetFolderItem && resultSetFolderItem.goToNextRow()) {
          let itemDb: GridLayoutItemInfoDB = GridLayoutItemDbBuilder.fromResultSet(resultSetFolderItem).buildGridLayoutItemDB();
          if (!itemDb.bundleName || itemDb.bundleName === 'com.ohos.findservice' ||
            (!DeviceHelper.isSupportVoiceCapability() && itemDb.typeId === CommonConstants.TYPE_SHORTCUT_ICON &&
              itemDb.bundleName === 'com.ohos.contacts')) {
            let predicates = new rdb.RdbPredicates(tableName);
            predicates.equalTo(GridLayoutInfoColumns.ID, itemDb.id);
            let row: number = await rdbStoreHelper.delete(predicates, context, SceneMsgEnum.DELETE_QUERY_SMART_DOCK_FOLDER, false, 0, tableName);
            log.showInfo(`querySmartdock delete null data ${row} rows in folder`);
            continue;
          }
          folderItem.push(itemDb.toGridLayoutItemInfo());
        }
        // 按照页->行->列对文件夹中应用排序
        folderItem.sort((appItem1, appItem2): number => {
          if (appItem1.page === appItem2.page) {
            if (appItem1.row === appItem2.row) {
              return (appItem1.column ?? 0) - (appItem2.column ?? 0);
            }
            return (appItem1.row ?? 0) - (appItem2.row ?? 0);
          }
          return (appItem1.page ?? 0) - (appItem2.page ?? 0);
        });
        resultSetFolderItem?.close();
        tempArray.push(folderItem);
        itemInfo.layoutInfo = tempArray;
      } else {
        if (!itemInfo.bundleName || itemInfo.bundleName === 'com.ohos.findservice' ||
          (!DeviceHelper.isSupportVoiceCapability() && itemInfo.typeId === CommonConstants.TYPE_SHORTCUT_ICON &&
            itemInfo.bundleName === 'com.ohos.contacts')) {
          let predicates = new rdb.RdbPredicates(tableName);
          predicates.equalTo(GridLayoutInfoColumns.ID, itemInfo.id);
          let row: number = await rdbStoreHelper.delete(predicates, context, SceneMsgEnum.DELETE_QUERY_SMART_DOCK_FOLDER, false, 0, tableName);
          log.showInfo(`querySmartdock delete null data ${row} rows`);
          continue;
        }
        itemInfo.keyName = `${itemInfo.bundleName}${itemInfo.abilityName}${itemInfo.moduleName}${itemInfo.appIndex ??
          0}${itemInfo.shortcutId ?? ''}`;
      }

      // 删除appIndex为null的脏数据
      if (keyNameSet.has(itemInfo.keyName)) {
        let predicates = new rdb.RdbPredicates(tableName);
        predicates.equalTo(GridLayoutInfoColumns.BUNDLE_NAME, itemInfo.bundleName)
          .and().equalTo(GridLayoutInfoColumns.ABILITY_NAME, itemInfo.abilityName)
          .and().isNull(GridLayoutInfoColumns.APP_INDEX)
          .and().equalTo(GridLayoutInfoColumns.CONTAINER, CommonConstants.CONTAINER_SMARTDOCK);
        let row = await rdbStoreHelper.delete(predicates, context, SceneMsgEnum.DELETE_QUERY_SMART_DOCK_FOLDER, false, 0, tableName);
        log.showInfo(`querySmartdock delete ${row} rows, keName is ${itemInfo.keyName}`);
      } else {
        keyNameSet.add(itemInfo.keyName);
        resultList.push(itemInfo);
      }
    }
    resultSet?.close();
    resultSet = undefined;
  } catch (e) {
    log.showError(`querySmartDock error:${JSON.stringify(e)}`);
  }
  log.showInfo(`querySmartDock resultList.length: ${resultList.length}`);
  return resultList;
}

/**
 * 查询Dock区最近任务，container = -102
 *
 * @returns 最近任务应用列表
 */
async function queryRecentDock(tableName: string, context: Context.BaseContext): Promise<DockItemInfo[]> {
  'use concurrent';
  const TAG = 'taskPool';
  const resultList: DockItemInfo[] = [];
  const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
  try {
    let predicates = new rdb.RdbPredicates(tableName);
    // 按照列升序查询
    predicates.orderByAsc(RecentDockInfoColumns.COLUMN);
    let resultSet: rdb.ResultSet | undefined = await rdbStoreHelper.query(predicates, [], context);
    while (resultSet && resultSet.goToNextRow()) {
      let itemInfo: DockItemInfo = new DockItemInfo();
      itemInfo.editable = false;
      itemInfo.bundleName = resultSet.getString(resultSet.getColumnIndex(RecentDockInfoColumns.BUNDLE_NAME));
      itemInfo.abilityName = resultSet.getString(resultSet.getColumnIndex(RecentDockInfoColumns.ABILITY_NAME));
      itemInfo.moduleName = resultSet.getString(resultSet.getColumnIndex(RecentDockInfoColumns.MODULE_NAME));
      itemInfo.appLabelId = resultSet.getLong(resultSet.getColumnIndex(RecentDockInfoColumns.APP_LABEL_ID));
      itemInfo.appIndex = resultSet.getLong(resultSet.getColumnIndex(RecentDockInfoColumns.APP_INDEX));
      itemInfo.applicationLabelId = itemInfo.appLabelId;
      itemInfo.keyName = `${itemInfo.bundleName}${itemInfo.abilityName}${itemInfo.moduleName}${itemInfo.appIndex ?? 0}${itemInfo.shortcutId ?? ''}`;
      itemInfo.visible = true;
      itemInfo.itemType = CommonConstants.TYPE_APP;
      resultList.push(itemInfo);
    }
    resultSet?.close();
    resultSet = undefined;
  } catch (e) {
    log.showError(`queryRecentDock error:${JSON.stringify(e)}`);
  }
  log.showInfo(`queryRecentDock length: ${resultList.length}`);
  return resultList;
}

/**
 * 查询Dock区的最近任务应用数量
 *
 * @returns 最近任务应用列表
 */
async function queryRecentDockInfo(tableName: string, context: Context.BaseContext): Promise<number> {
  'use concurrent';
  const TAG = 'taskPool';
  const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
  let visibleCount: number = 0;
  try {
    let predicates = new rdb.RdbPredicates(tableName);
    // 按照列升序查询
    predicates.orderByAsc(RecentDockLayoutInfoColumns.VISIBLE_COUNT);
    let resultSet: rdb.ResultSet | undefined = await rdbStoreHelper.query(predicates, [], context);
    while (resultSet && resultSet.goToNextRow()) {
      visibleCount = resultSet.getLong(resultSet.getColumnIndex(RecentDockLayoutInfoColumns.VISIBLE_COUNT));
    }
    resultSet?.close();
    resultSet = undefined;
  } catch (e) {
    log.showError(`queryRecentDockInfo error:${JSON.stringify(e)}`);
  }
  log.showInfo(`queryRecentDockInfo : ${visibleCount}`);
  return visibleCount;
}

async function queryGridLayoutByType(tableName: string, typeId: number, context: Context.BaseContext): Promise<GridLayoutItemInfo[]> {
  'use concurrent';
  const TAG = 'taskPool';
  const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
  log.showWarn('queryGridLayoutByType typeId: %{public}d', typeId);
  let resultList: GridLayoutItemInfo[] = [];
  try {
    const predicates = new rdb.RdbPredicates(tableName);
    predicates.equalTo(GridLayoutInfoColumns.TYPE_ID, typeId);
    let resultSet: rdb.ResultSet | undefined = await rdbStoreHelper.query(predicates, [], context);
    log.showWarn('queryGridLayoutByType query finish');
    while (resultSet && resultSet.goToNextRow()) {
      let itemDb: GridLayoutItemInfoDB = GridLayoutItemDbBuilder.fromResultSet(resultSet).buildGridLayoutItemDB();
      let item: GridLayoutItemInfo = itemDb.toGridLayoutItemInfo();
      resultList.push(item);
    }
    resultSet?.close();
    resultSet = undefined;
  } catch (e) {
    log.showError(`queryGridLayoutByType error:${JSON.stringify(e)}`);
  }
  log.showWarn('queryGridLayoutByType length: %{public}d', resultList.length);
  return resultList;
}

async function queryGridLayoutByContainer(tableName: string, container: number, context: Context.BaseContext): Promise<GridLayoutItemInfo[]> {
  'use concurrent';
  const TAG = 'taskPool';
  const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
  log.showInfo(`queryGridLayoutByContainer container: ${container}`);
  let resultList: GridLayoutItemInfo[] = [];
  try {
    const predicates = new rdb.RdbPredicates(tableName);
    predicates.equalTo(GridLayoutInfoColumns.CONTAINER, container);
    // 元素按照column和row升序查询
    predicates.orderByAsc(GridLayoutInfoColumns.COLUMN).and().orderByAsc(GridLayoutInfoColumns.ROW);
    let resultSet = await rdbStoreHelper.query(predicates, [], context);
    while (resultSet && resultSet.goToNextRow()) {
      let itemDb: GridLayoutItemInfoDB = GridLayoutItemDbBuilder.fromResultSet(resultSet).buildGridLayoutItemDB();
      let item: GridLayoutItemInfo = itemDb.toGridLayoutItemInfo();
      resultList.push(item);
    }
    resultSet?.close();
  } catch (e) {
    log.showError(`queryGridLayoutByContainer error:${JSON.stringify(e)}`);
  }
  return resultList;
}


async function isExistInGridLayout(target: string, conditions: Map<string, rdb.ValueType>, context: Context.BaseContext): Promise<boolean> {
  'use concurrent';
  const TAG = 'taskPool_isExistInGridLayout';
  const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
  log.showWarn(`isExistInGridLayout query start ${target}`);
  const predicates = new rdb.RdbPredicates(target);
  conditions?.forEach((value, key) => {
    predicates.and().equalTo(key, value);
  });
  let isExist: boolean = false;
  try {
    let resultSet = await rdbStoreHelper.query(predicates, [], context);
    if (resultSet && resultSet.goToNextRow()) {
      isExist = true;
    }
    resultSet?.close();
  } catch (e) {
    log.showError(`isExistInGridLayout error:${JSON.stringify(e)}`);
  }
  log.showWarn(`isExistInGridLayout query end ${isExist}`);
  return isExist;
}


/**
 * 更新下载信息
 *
 * @param appInfo：应用信息
 * @returns 数据库操作码。CommonConstants.INVALID_VALUE为失败
 */
async function updateDownloadInfo(tableName: string, appInfo: DownloadInfoItem, sceneMsg: string,
  context: Context.BaseContext): Promise<number> {
  'use concurrent';
  const TAG = 'taskPool appInstall';
  const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
  log.showWarn('updateDownloadInfo bundleName %{public}s, oldBundleName %{public}s',
    appInfo.bundleName, appInfo.oldBundleName);
  let rdbHelper: RdbStoreHelper = new RdbStoreHelper();
  let resultRow = CommonConstants.INVALID_VALUE;
  try {
    await rdbHelper.createRdbStore(context);
    let rdbStore: rdb.RdbStore = rdbHelper.getRdbStore();
    if (!rdbStore) {
      log.showError('updateDownloadInfo rdbStore error, rdbStore is null!');
      return resultRow;
    }
    rdbStore.beginTransaction();
    let predicates = new rdb.RdbPredicates(tableName)
      .equalTo(GridLayoutInfoColumns.TYPE_ID, CommonConstants.TYPE_APP);
    let whereSql: string = `${GridLayoutInfoColumns.TYPE_ID}=${CommonConstants.TYPE_APP}`;
    if (!appInfo.updateTwinApp) {
      predicates.equalTo(GridLayoutInfoColumns.APP_INDEX, appInfo.appIndex ?? CommonConstants.MAIN_APP_INDEX);
      whereSql += (` AND ${GridLayoutInfoColumns.APP_INDEX}=${appInfo.appIndex ?? CommonConstants.MAIN_APP_INDEX}`);
    }
    if (appInfo.oldBundleName) {
      predicates.equalTo(GridLayoutInfoColumns.BUNDLE_NAME, appInfo.oldBundleName);
      whereSql += (` AND ${GridLayoutInfoColumns.BUNDLE_NAME}=${appInfo.oldBundleName}`);
    } else {
      predicates.equalTo(GridLayoutInfoColumns.BUNDLE_NAME, appInfo.bundleName);
      whereSql += (` AND ${GridLayoutInfoColumns.BUNDLE_NAME}=${appInfo.bundleName}`);
    }
    if (appInfo.moduleName) {
      predicates.and().equalTo(GridLayoutInfoColumns.MODULE_NAME, appInfo.moduleName);
      whereSql += (` AND ${GridLayoutInfoColumns.BUNDLE_NAME}=${appInfo.moduleName}`);
    }
    if (appInfo.appIndex !== undefined) {
      predicates.and().equalTo(GridLayoutInfoColumns.APP_INDEX, appInfo.appIndex);
      whereSql += (` AND ${GridLayoutInfoColumns.APP_INDEX}=${appInfo.appIndex}`);
    }

    let valuesBucket: rdb.ValuesBucket = {};
    if (appInfo.oldBundleName && appInfo.bundleName) {
      valuesBucket[GridLayoutInfoColumns.BUNDLE_NAME] = appInfo.bundleName;
    }
    if (appInfo.iconResource) {
      valuesBucket[GridLayoutInfoColumns.ICON_RESOURCE] = appInfo.iconResource;
    }
    if (appInfo.appStatus !== undefined) {
      valuesBucket[GridLayoutInfoColumns.APP_STATUS] = appInfo.appStatus;
    }
    // 如果应用是安装状态，设置DOWNLOAD_PROGRESS为null
    if (appInfo.appStatus === AppStatus.INSTALLED) {
      valuesBucket[GridLayoutInfoColumns.DOWNLOAD_PROGRESS] = null;
    } else if (appInfo.downloadProgress) {
      valuesBucket[GridLayoutInfoColumns.DOWNLOAD_PROGRESS] = appInfo.downloadProgress;
    }
    if (appInfo.callerName) {
      valuesBucket[GridLayoutInfoColumns.CALLER_NAME] = appInfo.callerName;
    }
    if (appInfo.intent) {
      valuesBucket[GridLayoutInfoColumns.INTENT] = appInfo.intent;
    }
    let executeSql: string =
      `UPDATE ${tableName} SET ${rdbStoreHelper.valuesBucketToStr(valuesBucket)} WHERE ${whereSql}`;
    resultRow = await rdbHelper.update(predicates, valuesBucket, context, sceneMsg, false, 0, tableName);
    rdbStoreHelper.printExecuteSql('updateDownloadInfo', sceneMsg, executeSql, resultRow);
    rdbStore.commit();
  } catch (e) {
    log.showError('updateDownloadInfo error:%{public}s', e?.message);
    rdbHelper.getRdbStore()?.rollBack();
  } finally {
    log.showWarn('updateDownloadInfo end bundleName:%{public}s, resultRow:%{public}d', appInfo.bundleName, resultRow);
    rdbHelper.release();
  }
  return resultRow;
}

async function queryNotInstalledApplication(tableName: string, context: Context.BaseContext): Promise<string[]> {
  'use concurrent';
  const TAG = 'taskPool';
  const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
  let resultList: string[] = [];
  try {
    const predicates = new rdb.RdbPredicates(tableName);
    predicates.equalTo(GridLayoutInfoColumns.TYPE_ID, CommonConstants.TYPE_APP)
      .greaterThan(GridLayoutInfoColumns.APP_STATUS, AppStatus.INSTALLED)
      .notEqualTo(GridLayoutInfoColumns.APP_STATUS, AppStatus.WAIT_FOR_HARMONY);
    let resultSet = await rdbStoreHelper.query(predicates, [GridLayoutInfoColumns.BUNDLE_NAME], context);
    while (resultSet && resultSet.goToNextRow()) {
      resultList.push(resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.BUNDLE_NAME)));
    }
    resultSet?.close();
  } catch (err) {
    log.showError('queryNotInstalledApplication error: %{public}s', err?.message);
  }
  log.showInfo(`queryNotInstalledApplication resultList length: ${resultList.length}`);
  return resultList;
}

async function updateRelationFormInfoOfDb(tableName: string, relationCards: CardItemInfo[], sceneMsg: string,
  context: Context.BaseContext): Promise<boolean> {
  'use concurrent';
  const TAG = 'taskPool';
  const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
  log.showInfo('updateRelationFormInfoOfDb start');
  try {
    if (rdbStoreHelper.getRdbStore() === undefined && !rdbStoreHelper.createRdbStore(context)) {
      return false;
    }
    rdbStoreHelper.getRdbStore()?.beginTransaction();
    for (const cardItemInfo of relationCards) {
      let predicates = new rdb.RdbPredicates(tableName);
      predicates.equalTo(GridLayoutInfoColumns.INFO_ID, cardItemInfo.cardId);
      predicates.equalTo(GridLayoutInfoColumns.TYPE_ID, CommonConstants.TYPE_CARD);

      let valuesBucket: rdb.ValuesBucket = {
        [GridLayoutInfoEnums.INFO_NAME]: cardItemInfo.cardName,
        [GridLayoutInfoEnums.BUNDLE_NAME]: cardItemInfo.bundleName,
        [GridLayoutInfoEnums.ABILITY_NAME]: cardItemInfo.abilityName,
        [GridLayoutInfoEnums.MODULE_NAME]: cardItemInfo.moduleName,
        [GridLayoutInfoEnums.INFO_ID]: cardItemInfo.thirdAppRelationCardId
      };
      let executeSql: string =
        `UPDATE ${tableName} SET ${rdbStoreHelper.valuesBucketToStr(valuesBucket)} WHERE ${GridLayoutInfoColumns.INFO_ID}=${cardItemInfo.cardId} AND ${GridLayoutInfoColumns.TYPE_ID}=${CommonConstants.TYPE_CARD}`;
      let updateResult = await rdbStoreHelper.update(predicates, valuesBucket, context, sceneMsg, false, 0, tableName);
      rdbStoreHelper.printExecuteSql('updateRelationFormInfoOfDb', sceneMsg, executeSql, updateResult);
      if (updateResult === CommonConstants.INVALID_VALUE) {
        throw new Error('update error');
      }
    }
    rdbStoreHelper.getRdbStore()?.commit();
    log.showInfo('updateRelationFormInfoOfDb success');
    return true;
  } catch (e) {
    log.showError(`updateRelationFormInfoOfDb error:%{public}s`, e?.message);
    rdbStoreHelper.getRdbStore()?.rollBack();
  }
  return false;
}

async function deleteRelationFormInfoOfDb(tableName: string, deleteIds: string[], sceneMsg: string,
  context: Context.BaseContext): Promise<boolean> {
  'use concurrent';
  const TAG = 'taskPool';
  const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
  log.showInfo('deleteRelationFormInfoOfDb start');
  try {
    if (rdbStoreHelper.getRdbStore() === undefined && !rdbStoreHelper.createRdbStore(context)) {
      return false;
    }
    rdbStoreHelper.getRdbStore()?.beginTransaction();
    for (const infoId of deleteIds) {
      let predicates = new rdb.RdbPredicates(tableName);
      predicates.equalTo(GridLayoutInfoColumns.INFO_ID, infoId);
      let executeSql: string = `DELETE FROM ${tableName} WHERE ${GridLayoutInfoColumns.INFO_ID}=${infoId}`;
      let updateResult = await rdbStoreHelper.delete(predicates, context, sceneMsg, false, 0, tableName);
      rdbStoreHelper.printExecuteSql('deleteRelationFormInfoOfDb', sceneMsg, executeSql, updateResult);
      if (updateResult === CommonConstants.INVALID_VALUE) {
        throw new Error('delete error');
      }
    }
    rdbStoreHelper.getRdbStore()?.commit();
    log.showInfo('deleteRelationFormInfoOfDb success');
    return true;
  } catch (e) {
    log.showError(`deleteRelationFormInfoOfDb error:%{public}s`, e?.message);
    rdbStoreHelper.getRdbStore()?.rollBack();
  }
  return false;
}

async function deleteItemsByInfoIdAndContainer(tableName: string, deleteItems: GridLayoutItemInfo[], sceneMsg: string,
  context: Context.BaseContext): Promise<boolean> {
  'use concurrent';
  const TAG = 'taskPool';
  const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
  log.showInfo('deleteItemsByInfoIdAndContainer start');
  try {
    if (rdbStoreHelper.getRdbStore() === undefined && !rdbStoreHelper.createRdbStore(context)) {
      return false;
    }
    rdbStoreHelper.getRdbStore()?.beginTransaction();
    for (const item of deleteItems) {
      if (CheckEmptyUtils.isEmpty(item.infoId) || CheckEmptyUtils.isEmpty(item.container)) {
        log.showError('info id or container is empty.');
        continue;
      }
      let predicates = new rdb.RdbPredicates(tableName);
      predicates.equalTo(GridLayoutInfoColumns.INFO_ID, item.infoId)
      .equalTo(GridLayoutInfoColumns.CONTAINER, item.container);
      let executeSql: string =
        `DELETE FROM ${tableName} WHERE ${GridLayoutInfoColumns.INFO_ID}=${item.infoId} AND ${GridLayoutInfoColumns.CONTAINER}=${item.container}`;
      let deleteResult = await rdbStoreHelper.delete(predicates, context, sceneMsg, false, 0, tableName);
      rdbStoreHelper.printExecuteSql('deleteItemsByInfoIdAndContainer', sceneMsg, executeSql, deleteResult);
      if (deleteResult === CommonConstants.INVALID_VALUE) {
        throw new Error('delete error');
      }
    }
    rdbStoreHelper.getRdbStore()?.commit();
    log.showInfo('deleteItemsByInfoIdAndContainer success');
    return true;
  } catch (e) {
    log.showError(`deleteItemsByInfoIdAndContainer error:%{public}s`, e?.message);
    rdbStoreHelper.getRdbStore()?.rollBack();
  }
  return false;
}
