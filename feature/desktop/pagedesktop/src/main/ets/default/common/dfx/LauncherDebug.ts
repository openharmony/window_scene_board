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

import { CheckEmptyUtils, LogDomain, Logger } from '@ohos/basicutils';
import { SCBConstants } from '@ohos/commonconstants';
import { DebugCommand, DebugCommandManager, GlobalContext, rdbStoreHelper } from '@ohos/frameworkwrapper';
import { GridLayoutItemInfo, RdbStoreManager } from '@ohos/launchercommon';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import rdb from '@ohos.data.relationalStore';
import { settings } from '@kit.BasicServicesKit';

const TAG = 'LauncherDebug';
const log: Logger = Logger.getLogHelper(LogDomain.HOME);
const SET_ICON_DATA_PARAMETERS_LENGTH = 3;
const SET_PARAMETER_LENGTH = 1;
const LAUNCHER_DB_SQL_VERSION = 'launcher_db_sql_version';

/**
 * 桌面Debug
 */
export class LauncherDebug {
  private static instance: LauncherDebug;
  private desktopContext?: ServiceExtensionContext = GlobalContext.getContext();

  public static getInstance(): LauncherDebug {
    if (!LauncherDebug.instance) {
      LauncherDebug.instance = new LauncherDebug();
    }
    return LauncherDebug.instance;
  }

  private constructor() {
    DebugCommandManager.getInstance().register(TAG, this.getCommands());
  }

  private getCommands(): DebugCommand[] {
    let cmds: DebugCommand[] = [];
    // hdc shell hidumper -s 4606 -a "-b LauncherDebug setIconDataValue com.ss.hm.article.news iconOpacity 0"
    cmds.push({
      cmdName: 'setIconDataValue',
      callback: (args: Array<string>) => this.setIconDataValue(args)
    });
    cmds.push({
      cmdName: 'setRDBInsertError',
      callback: (args: Array<string>) => this.setRDBInsertError(args)
    });
    cmds.push({
      cmdName: 'setInstalledStatusFailed',
      callback: (args: Array<string>) => this.setInstalledStatusFailed(args)
    });
    // hdc shell hidumper -s 4606 -a "-b LauncherDebug setRdbSqlVersion 0"
    cmds.push({
      cmdName: 'setRdbSqlVersion',
      callback: (args: Array<string>) => this.setRdbSqlVersion(args)
    });
    return cmds;
  }

  private setRdbSqlVersion(args: Array<string>): string {
    if (CheckEmptyUtils.isEmptyArr(args) || args.length !== SET_PARAMETER_LENGTH) {
      return 'please check your parameters: [0]rdbVersion(number)...\n';
    }
    let sqlVersion: number = Number.parseInt(args[0]);
    if(sqlVersion < 0){
      return `please check your parameter is greater than or equal to 0.`;
    }
    settings.setValueSync((GlobalContext.getContext()), LAUNCHER_DB_SQL_VERSION, sqlVersion.toString(), settings.domainName.USER_PROPERTY);
    return `debug setRdbSqlVersion ${sqlVersion} has been set.`;
  }

  private setInstalledStatusFailed(args: Array<string>): string {
    if (CheckEmptyUtils.isEmptyArr(args) || args.length !== SET_PARAMETER_LENGTH) {
      return 'please check your parameters: [0]debugStatus(boolean)...\n';
    }
    let debugStatus: number = Number.parseInt(args[0]);
    RdbStoreManager.getInstance().setDebugStatus(debugStatus);
    return `debug installStatusErro has set debugStatus:${debugStatus}`;
  }

  private setIconDataValue(args: Array<string>): string {
    if (CheckEmptyUtils.isEmptyArr(args) || args.length !== SET_ICON_DATA_PARAMETERS_LENGTH) {
      return 'please check your parameters: [0]bundleName  [1]iconData property [2]value...\n';
    }
    let bundleName: string = args[0];
    let iconDataProperty: string = args[1];
    let setValue: string = args[2];
    this.desktopContext?.eventHub.emit(SCBConstants.ICON_DATA_DEBUG, bundleName, iconDataProperty, setValue);
    return `set ${bundleName} iconData property ${iconDataProperty} = ${setValue}`;
  }

  private setRDBInsertError(args: Array<string>): string {
    if (CheckEmptyUtils.isEmptyArr(args) || args.length !== SET_PARAMETER_LENGTH) {
      return 'please check your parameters: [0]bundleName  [1]iconData property [2]value...\n';
    }
    let scene = Number.parseInt(args[0]);
    switch (scene) {
      case RDBDebugScene.INSERT_PARAM_EMPTY:
        this.debugInsertParmEmpty();
        break;
      case RDBDebugScene.INSERT_BACK_STATUS:
        this.debugInsertBackStatus();
        break;
      case RDBDebugScene.INSERT_DUPLICATE_POSITION:
        this.debugInsertDuplicatePosition();
        break;
      case RDBDebugScene.INSERT_ERROR:
        this.debugInsertError();
        break;
      case RDBDebugScene.QUERY_ERROR:
        this.debugQueryError();
        break;
    }
    return `debug setRDBInsertError scene:${scene}`;
  }

  private debugQueryError(): void {
    let predicates = new rdb.RdbPredicates('grid_layout_info_invalid');
    predicates.beginWrap();
    predicates.equalTo('container', 100);
    predicates.endWrap();
    rdbStoreHelper.query(predicates, [], GlobalContext.getContext());
    log.showInfo(TAG, `debugQueryError finished`);
  }

  private debugInsertParmEmpty(): void {
    RdbStoreManager.getInstance().insertGridLayoutInfo(undefined);
  }

  private debugInsertError(): void {
    let valuesBucket: rdb.ValuesBucket = {
      id: '0',
      data: 'grid_layout_info_insert_error_error_report',
    }
    rdbStoreHelper.insert('grid_layout_info_error', valuesBucket, GlobalContext.getContext());
    log.showInfo(TAG, `debugInsertError finished`);
  }

  private async debugInsertDuplicatePosition(): Promise<void> {
    let duplicateGridLayoutInfos: GridLayoutItemInfo[] = await RdbStoreManager.getInstance().queryAllGridLayoutInfo();
    if (!CheckEmptyUtils.isEmptyArr(duplicateGridLayoutInfos) && duplicateGridLayoutInfos.length >= 2) {
      duplicateGridLayoutInfos[1].page = duplicateGridLayoutInfos[0].page;
      duplicateGridLayoutInfos[1].container = duplicateGridLayoutInfos[0].container;
      duplicateGridLayoutInfos[1].area = duplicateGridLayoutInfos[0].area;
      duplicateGridLayoutInfos[1].row = duplicateGridLayoutInfos[0].row;
      duplicateGridLayoutInfos[1].column = duplicateGridLayoutInfos[0].column;
    }
    RdbStoreManager.getInstance().insertGridLayoutInfo(duplicateGridLayoutInfos, true);
    log.showInfo(TAG, `debugInsertDuplicatePosition finished`);
  }

  private async debugInsertBackStatus(): Promise<void> {
    let gridLayoutInfos: GridLayoutItemInfo[] = await RdbStoreManager.getInstance().queryAllGridLayoutInfo();
    let tempIsBackUpService: boolean = GlobalContext.getInstance().getObject('isBackupService') as boolean;
    let tempBackupStatus: boolean = GlobalContext.getInstance().getObject('backupStatus') as boolean;
    GlobalContext.getInstance().setObject('isBackupService', false);
    GlobalContext.getInstance().setObject('backupStatus', true);
    RdbStoreManager.getInstance().insertGridLayoutInfo(gridLayoutInfos, true);
    // 恢复现场
    GlobalContext.getInstance().setObject('isBackupService', tempIsBackUpService);
    GlobalContext.getInstance().setObject('backupStatus', tempBackupStatus);
    log.showInfo(TAG, `debugInsertBackStatus finished`);
  }
}

export enum RDBDebugScene {
  INSERT_PARAM_EMPTY = 0,
  INSERT_BACK_STATUS = 1,
  INSERT_DUPLICATE_POSITION = 2,
  INSERT_ERROR = 3,
  QUERY_ERROR = 4,
  UPDATE_ERROR = 5,
  DELETE_ERROR = 6,
}

export enum StartupStep {
  INSERT_PARAM_EMPTY = 0,
  INSERT_BACK_STATUS = 1,
  INSERT_DUPLICATE_POSITION = 2,
  INSERT_ERROR = 3,
  QUERY_ERROR = 4,
  UPDATE_ERROR = 5,
  DELETE_ERROR = 6,
}
