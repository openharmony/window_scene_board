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

import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import {
  ContractedFolderCommonViewModel,
  FolderOperationFlag,
  GridLayoutItemInfo
} from '../../../../../TsIndex';
import { FolderLifeCyclePriority } from '../../FolderCommonConstant';

const TAG = 'FolderActionLifeCycleEventManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

type notifyEventCallback = (obs: FolderActionLifeCycleEvent, folder: GridLayoutItemInfo) => void;

/**
 * 文件夹操作生命周期管理类
 */
export class FolderActionLifeCycleEventManager {
  private static instance: FolderActionLifeCycleEventManager;
  private obsArray: FolderActionLifeCycleEvent[] = [];
  private callbacks: Map<FolderActionLifeCycleStatus, notifyEventCallback> =
    new Map<FolderActionLifeCycleStatus, notifyEventCallback>([
      [FolderActionLifeCycleStatus.OPENING, (obs, folder): void => obs.onOpeningFolder?.(folder)],
      [FolderActionLifeCycleStatus.OPENED, (obs, folder): void => obs.onOpenedFolder?.(folder)],
      [FolderActionLifeCycleStatus.CLOSING, (obs, folder): void => obs.onClosingFolder?.(folder)],
      [FolderActionLifeCycleStatus.CLOSED, (obs, folder): void => obs.onClosedFolder?.(folder)],
      [FolderActionLifeCycleStatus.CONVERTING, (obs, folder): void => obs.onConvertingFolder?.(folder)],
      [FolderActionLifeCycleStatus.CONVERTED, (obs, folder): void => obs.onConvertedFolder?.(folder)],
      [FolderActionLifeCycleStatus.DISBANDING, (obs, folder): void => obs.onDisbandingFolder?.(folder)],
      [FolderActionLifeCycleStatus.DISBANDED, (obs, folder): void => obs.onDisbandedFolder?.(folder)],
      [FolderActionLifeCycleStatus.PRESSING, (obs, folder): void => obs.onPressingFolder?.(folder)],
      [FolderActionLifeCycleStatus.PRESSED, (obs, folder): void => obs.onPressedFolder?.(folder)],
      [FolderActionLifeCycleStatus.CANCEL_PRESS, (obs, folder): void => obs.cancelPressAnimation?.(folder)],
      [FolderActionLifeCycleStatus.BREAK_PRESS, (obs, folder): void => obs.breakPressAnimation?.(folder)],
      [FolderActionLifeCycleStatus.MENU_SHOW, (obs, folder): void => obs.onFolderMenuShow?.(folder)],
      [FolderActionLifeCycleStatus.MENU_HIDDEN, (obs, folder): void => obs.onFolderMenuHidden?.(folder)],
      [FolderActionLifeCycleStatus.PLACEHOLDER_SHOW, (obs, folder): void => obs.onPlaceHolderShow?.(folder)],
      [FolderActionLifeCycleStatus.DRAG_TO_FOLDER, (obs, folder): void => obs.onDragToFolder?.(folder)],
      [FolderActionLifeCycleStatus.INSTALLING_FOLDER, (obs, folder): void => obs.onInstallingFolder?.(folder)],
      [FolderActionLifeCycleStatus.INSTALLED_FOLDER, (obs, folder): void => obs.onInstalledFolder?.(folder)],
      [FolderActionLifeCycleStatus.BACKPLANE_ZOOM_IN, (obs, folder): void => obs.onBackplaneZoomIn?.(folder)],
      [FolderActionLifeCycleStatus.BACKPLANE_ZOOM_OUT, (obs, folder): void => obs.onBackplaneZoomOut?.(folder)],
      [FolderActionLifeCycleStatus.APP_EXIT, (obs, folder): void => obs.onAppExit?.(folder)],
      [FolderActionLifeCycleStatus.ICON_CLICK, (obs, folder): void => obs.onIconClick?.(folder)]
    ]);

  static getInstance(): FolderActionLifeCycleEventManager {
    if (!FolderActionLifeCycleEventManager.instance) {
      FolderActionLifeCycleEventManager.instance = new FolderActionLifeCycleEventManager();
    }
    return FolderActionLifeCycleEventManager.instance;
  }

  private constructor() {
  }

  /**
   * 注册文件夹操作生命周期事件
   *
   * @param obs 事件回调实例
   */
  public register(obs: FolderActionLifeCycleEvent): void {
    if (obs.folderId === undefined) {
      log.showDebug('register folder callback for all folder');
    }

    let index: number = this.obsArray.findIndex((item: FolderActionLifeCycleEvent) => item.priority < obs.priority);
    if (index > -1) {
      this.obsArray.splice(index, 0, obs);
    } else {
      this.obsArray.push(obs);
    }
  }

  /**
   * 去注册文件夹操作生命周期事件
   *
   * @param obs 事件回调实例
   */
  public unregister(obs: FolderActionLifeCycleEvent): void {
    let index = this.obsArray.findIndex((item) => {
      return item === obs;
    });
    if (index < 0) {
      log.showWarn('cannot find registered event from %{public}s:%{public}s', obs.description, obs.folderId);
      return;
    }
    this.obsArray.splice(index, 1);
  }

  /**
   * 去掉注册的文件夹操作生命周期事件
   *
   * @param folderId 文件夹id
   */
  public unregisterByFolderId(folderId: string): void {
    let index = this.obsArray.findIndex((item) => {
      return item.folderId === folderId;
    });
    if (index < 0) {
      log.showWarn('cannot find registered event from %{public}s', folderId);
      return;
    }
    this.obsArray.splice(index, 1);
  }

  /**
   * 通知文件夹生命周期事件发生
   *
   * @param msg 触发事件的场景描述，DFX用
   * @param folder 当前目录
   * @param status 事件
   */
  public notify(msg: string, folder: GridLayoutItemInfo, status: FolderActionLifeCycleStatus): void {
    let callback = this.callbacks.get(status) as notifyEventCallback;
    if (!callback) {
      log.showError(`cannot find status(${status} callback`);
      return;
    }
    let tmpArray: FolderActionLifeCycleEvent[] = this.obsArray.slice();
    log.showInfo(`trigger notify on folder(${folder.folderId}) with reason(${msg}) length ${tmpArray.length}`);
    // 复制一份回调列表，避免回调执行过程中，有新的回调注册尽量，导致部分回调遗漏执行
    tmpArray.forEach((obs: FolderActionLifeCycleEvent) => {
      if (obs.folderId === undefined || obs.folderId === folder.folderId) {
        try {
            callback(obs, folder);
        } catch (err) {
          this.resetErrorStateChange(msg, status, folder.folderId as string, obs.isStateChange as boolean);
          log.showError(`oops! some exception happended on folder(${folder.folderId}), observer on ${obs.description} stack ${err.stack}`);
        }
      }
    });
  }

  private resetErrorStateChange(msg: string, status: FolderActionLifeCycleStatus, folderId: string,
    isStateChange: boolean): void {
    if (!isStateChange) {
      return;
    }
    switch (status) {
      case FolderActionLifeCycleStatus.DISBANDING:
      case FolderActionLifeCycleStatus.DISBANDED:
        ContractedFolderCommonViewModel.getInstance().disbandFolder(msg, folderId, FolderOperationFlag.REPAIR);
        break;
      default:
        break;
    }
  }


  /**
   * 获取注册的DEBUG描述信息
   *
   * @returns 汇总字符串
   */
  public getCallbackDesc(): string {
    let ret: string = 'there has ' + this.obsArray.length + ' modules registered event \r\n';
    let desc: string = '';

    ret += 'Index'.padEnd(8, ' ') + 'Name'.padEnd(48, ' ') +
    'Priority'.padEnd(12, ' ') + 'ListenFolderId'.padEnd(32, ' ') +
    'onOpeningFolder'.padEnd(24, ' ') + 'onOpenedFolder'.padEnd(24, ' ') +
    'onClosingFolder'.padEnd(24, ' ') + 'onClosedFolder'.padEnd(24, ' ') +
    'onResizingFolder'.padEnd(24, ' ') + 'onResizedFolder'.padEnd(24, ' ') +
    'onConvertingFolder'.padEnd(24, ' ') + 'onConvertedFolder'.padEnd(24, ' ') +
      '\r\n';
    this.obsArray.forEach((obs, index) => {
      ret += (index + 1).toString().padEnd(8, ' ') + obs.description.padEnd(48, ' ') +
      obs.priority.toString().padEnd(12, ' ') + (obs.folderId ?? 'all').padEnd(32, ' ') +
      (obs.onOpeningFolder ? 'Y' : 'N').padEnd(24, ' ') + (obs.onOpenedFolder ? 'Y' : 'N').padEnd(24, ' ') +
      (obs.onClosingFolder ? 'Y' : 'N').padEnd(24, ' ') + (obs.onClosedFolder ? 'Y' : 'N').padEnd(24, ' ') +
      (obs.onConvertingFolder ? 'Y' : 'N').padEnd(24, ' ') + (obs.onConvertedFolder ? 'Y' : 'N').padEnd(24, ' ') +
        '\r\n';

      if (!obs.getDescription) {
        return;
      }
      desc += '\r\nmodule: ' + obs.description + ' description below\r\n';
      desc += obs.getDescription() + '\r\n';
    });

    return ret + desc;
  }
}

/**
 * 文件夹操作状态
 */
export enum FolderActionLifeCycleStatus {
  OPENING,
  OPENED,
  CLOSING,
  CLOSED,
  CONVERTING,
  CONVERTED,
  DISBANDING,
  DISBANDED,
  PRESSING,
  PRESSED,
  CANCEL_PRESS,
  BREAK_PRESS,
  MENU_SHOW,
  MENU_HIDDEN,
  PLACEHOLDER_SHOW,
  DRAG_TO_FOLDER,
  INSTALLING_FOLDER,
  INSTALLED_FOLDER,
  BACKPLANE_ZOOM_IN,
  BACKPLANE_ZOOM_OUT,
  APP_EXIT,
  ICON_CLICK
}

/*
 * 文件夹ViewModel层相关生命周期事件，用于让各文件夹ViewModel特性（或者包括非文件夹）监听文件夹各种状态变化。
 * 请在务必注意在ViewModel层使用；允许在回调中修改Model；刷新View
 * 注册实例的方法比注册回调不容易写出内存泄漏
 */
export interface FolderActionLifeCycleEvent {
  /* 监听的文件夹Id，如果为空，则监听全量文件夹操作 */
  folderId?: string;

  /* 系列callback的唯一名称 */
  description: string;

  /* 回调优先级 */
  priority: FolderLifeCyclePriority;

  /* 是否涉及状态切换，外部注册回调该值为false或不填，供文件夹内部状态切换异常是恢复初始状态使用 */
  isStateChange?: boolean;

  /* 获取描述信息，DFX用 */
  getDescription?: () => string;

  /* 刚点击文件夹准备打开 */
  onOpeningFolder?: (folder: GridLayoutItemInfo) => void;

  /* 文件夹打开完成 */
  onOpenedFolder?: (folder: GridLayoutItemInfo) => void;

  /* 刚点击空白文件夹准备收起 */
  onClosingFolder?: (folder: GridLayoutItemInfo) => void;

  /* 文件夹收起完成 */
  onClosedFolder?: (folder: GridLayoutItemInfo) => void;

  /* 进入转换态 */
  onConvertingFolder?: (folder: GridLayoutItemInfo) => void;

  /* 退出转换态 */
  onConvertedFolder?: (folder: GridLayoutItemInfo) => void;

  /* 进入解散状态 */
  onDisbandingFolder?: (folder: GridLayoutItemInfo) => void;

  /* 退出解散状态 */
  onDisbandedFolder?: (folder: GridLayoutItemInfo) => void;

  /* 进入按压状态 */
  onPressingFolder?: (folder: GridLayoutItemInfo) => void;

  /* 退出按压状态 */
  onPressedFolder?: (folder: GridLayoutItemInfo) => void;

  /* 取消长按动画 */
  cancelPressAnimation?: (folder: GridLayoutItemInfo) => void;

  /* 打断长按动画 */
  breakPressAnimation?: (folder: GridLayoutItemInfo) => void;

  /* 文件夹菜单显示 */
  onFolderMenuShow?: (folder: GridLayoutItemInfo) => void;

  /* 文件夹菜单隐藏 */
  onFolderMenuHidden?: (folder: GridLayoutItemInfo) => void;

  /* 占位图标显示 */
  onPlaceHolderShow?: (folder: GridLayoutItemInfo) => void;

  /* 拖拽到文件夹 */
  onDragToFolder?: (folder: GridLayoutItemInfo) => void;

  /* 下载中的文件夹 */
  onInstallingFolder?: (folder: GridLayoutItemInfo) => void;

  /* 下载完成的文件夹 */
  onInstalledFolder?: (folder: GridLayoutItemInfo) => void;

  /* 背板放大 */
  onBackplaneZoomIn?: (folder: GridLayoutItemInfo) => void;

  /* 背板缩小 */
  onBackplaneZoomOut?: (folder: GridLayoutItemInfo) => void;

  /* 堆叠图标退出 */
  onAppExit?: (folder: GridLayoutItemInfo) => void;

  /* 文件夹图标点击 */
  onIconClick?: (folder: GridLayoutItemInfo) => void;
}