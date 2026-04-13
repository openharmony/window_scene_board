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

import { LogDomain, Logger } from '@ohos/basicutils';
import type { IService } from '@ohos/componenthelper';
import { IExecutor } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { Response } from '@ohos/launchercommon/src/main/ets/launchericon/viewmodel/ShortcutViewModel';
import { FileFolderShortCutViewModel } from '../viewmodel/FileFolderShortCutViewModel';
import { DesktopItemPosition } from '../common/bean/DesktopItemPosition';
import { GridLayoutItemInfo,  GridLayoutItemBuilder } from '@ohos/launchercommon';

const TAG: string = 'FileFolderService';
const log = Logger.getLogHelper(LogDomain.HOME);

/**
 * 请求方法
 */
export const enum RequestMethod {
  /**
   * 创建快捷方式
   */
  CREATE_SHORTCUT = 'createShortCut',
  /**
   * 取消创建快捷方式
   */
  CANCEL_SHORTCUT = 'cancelShortCut',
}


/**
 * 创建快捷方式
 */
export class CreateShortcutExecutor implements IExecutor {
  async execute(extra?: object): Promise<string> {
    if (!extra) {
      return Result.error(ResultMessage.PARAM_EMPTY_ERROR);
    }
    let action = extra as FileShortCutDesktopAction;
    if (!action) {
      return Result.error(ResultMessage.PARAM_EMPTY_ERROR);
    }
    if (!action.uri) {
      return Result.error(ResultMessage.PARAM_URI_EMPTY_ERROR);
    }
    log.showInfo(TAG, `createShortcut.execute ${action?.actionId}`);
    const desktopPosition = FileFolderService.popDesktopPosition(action.actionId);
    if (!desktopPosition) {
      return Result.error(ResultMessage.ACTION_ID_DATA_NOT_FOUND);
    }
    let shortcutItemInfo = FileFolderService.assembleGridLayoutItemInfo(action, desktopPosition);
    const success = FileFolderShortCutViewModel.getInstance().preStoreDesktopPosition(shortcutItemInfo);
    return success ? Result.ok(ResultMessage.SUCCESS) : Result.error(ResultMessage.PRE_STORE_ERROR);
  }
}

/**
 * 取消创建快捷方式
 */
export class CancelShortcutExecutor implements IExecutor {
  async execute(extra?: object): Promise<string> {
    if (!extra) {
      return Result.error(ResultMessage.PARAM_EMPTY_ERROR);
    }
    let action = extra as FileShortCutDesktopAction;
    if (!action) {
      return Result.error(ResultMessage.PARAM_EMPTY_ERROR);
    }
    log.showInfo(TAG, `CancelShortcut.execute ${action?.actionId}`);
    FileFolderService.deleteDesktopPosition(action.actionId);
    return Result.ok(ResultMessage.SUCCESS);
  }
}

/**
 * 桌面文件文件夹(包括快捷方式)业务服务
 */
export class FileFolderService implements IService {
  private static readonly executorMap: Map<string, () => IExecutor> = new Map<string, () => IExecutor>([
    [RequestMethod.CREATE_SHORTCUT, (): IExecutor => new CreateShortcutExecutor()],
    [RequestMethod.CANCEL_SHORTCUT, (): IExecutor => new CancelShortcutExecutor()],
  ]);

  private static actionId2DesktopPostion: Map<number, DesktopItemPosition> = new Map();

  async onCall(json: string): Promise<string> {
    let msg: CallMessage | undefined;
    try {
      msg = JSON.parse(json) as CallMessage;
    } catch (err) {
      log.showError(TAG, `onCall parse message failed, ${err?.code}`);
    }
    if (!msg || !msg.method) {
      log.showWarn(TAG, 'onCall invalid method');
      return Result.error(Response.INVALID_METHOD_ERROR);
    }

    const method: string = msg.method;
    log.showInfo(TAG, `onCall method = ${method}`);
    const executor = FileFolderService.executorMap.get(method);
    if (!executor) {
      log.showWarn(TAG, `onCall unknown method = ${method}`);
      return Result.error(Response.UNKNOWN_METHOD_ERROR);
    }
    return executor().execute(msg.extra);
  }

  isSupportSegments(): boolean {
    return true;
  }

  public static setDesktopPosition(actionId: number, desktopPosition: DesktopItemPosition): void {
    if (!actionId || !desktopPosition) {
      log.showError(TAG, 'setDesktopPosition, invalid param');
      return;
    }
    if (FileFolderService.actionId2DesktopPostion.has(actionId)) {
      log.showError(TAG, `duplicate actionId error ${actionId}`);
      return ;
    }
    FileFolderService.actionId2DesktopPostion.set(actionId, desktopPosition);
    log.showInfo(TAG, `setDesktopPosition, ${actionId}`);
  }

  public static deleteDesktopPosition(actionId: number): void {
    if (!FileFolderService.actionId2DesktopPostion.has(actionId)) {
      log.showWarn(TAG, `delete actionId not found, ${actionId}`);
      return;
    }
    log.showInfo(TAG, `delete actionId, ${actionId}`);
    FileFolderService.actionId2DesktopPostion.delete(actionId);
  }

  public static popDesktopPosition(actionId: number): DesktopItemPosition | undefined {
    if (!FileFolderService.actionId2DesktopPostion.has(actionId)) {
      log.showWarn(TAG, `get actionId not found, ${actionId}`);
      return undefined;
    }
    log.showInfo(TAG, `get actionId, ${actionId}`);
    const itemPosition = FileFolderService.actionId2DesktopPostion.get(actionId) as DesktopItemPosition;
    FileFolderService.deleteDesktopPosition(actionId);
    return itemPosition;
  }

  public static assembleGridLayoutItemInfo(action: FileShortCutDesktopAction , desktopPosition: DesktopItemPosition):
    GridLayoutItemInfo {
    return new GridLayoutItemBuilder(action.actionId).setUri(action.uri).setColumn(desktopPosition.column).
      setRow(desktopPosition.row).setPage(desktopPosition.page).buildGridLayoutItem();
  }

  public static generateActionId(): number {
    return ShortCutActionIdGenerator.generate();
  }

}

class ShortCutActionIdGenerator {
  private static id: number = 0;
  public static generate(): number {
    ShortCutActionIdGenerator.id++;
    return ShortCutActionIdGenerator.id;
  }
}

export class FileShortCutDesktopAction {
  public actionId: number = -1;
  public uri: string = '';

  constructor(actionId: number, uri: string) {
    this.actionId = actionId;
    this.uri = uri;
  }

  public toJSONString(): string {
    return JSON.stringify(this);
  }
}

/**
 * 请求消息
 */
export interface CallMessage {
  /**
   * 方法名
   */
  method: string;

  /**
   * 附加参数
   */
  extra: object;
}

/**
 * 返回值
 */
export class Result {
  /**
   * 0: 正常
   * -1： 异常
   */
  public code: number = 0;
  public message: string = '';

  private constructor(code: number, message: string) {
    this.code = code;
    this.message = message;
  }

  public static error(message: string): string {
    return JSON.stringify(new Result(ResultCode.ERROR, message))
  }

  public static ok(message: string): string {
    return JSON.stringify(new Result(ResultCode.OK, message))
  }

}

/**
 * 错误码
 */
export class ResultCode {
  public static readonly ERROR: number = -1;
  public static readonly OK: number = 0;
}

/**
 * 错误码
 */
export class ResultMessage {
  public static readonly SUCCESS: string = 'success';
  public static readonly PRE_STORE_ERROR: string = 'pre_store_error';
  public static readonly PARAM_EMPTY_ERROR: string = 'param_empty_error';
  public static readonly PARAM_TYPE_ERROR: string = 'param_type_error';
  public static readonly PARAM_URI_EMPTY_ERROR: string = 'param_uri_empty_error';
  public static readonly ACTION_ID_DATA_NOT_FOUND: string = 'actionId_data_not_found_error';

}