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

import { LogDomain, Logger } from '@ohos/basicutils/src/main/ets/TsIndex';
import { desktopUtil } from '@ohos/componenthelper';
import {
  FolderActionLifeCycleEventManager,
  FolderActionLifeCycleStatus,
  FolderActionLifeCycleStatusManager,
  FolderActionTransition,
  FolderManager,
  GridLayoutItemInfo
} from '@ohos/launchercommon/src/main/ets/TsIndex';
// import apsManager from '@hms.graphic.apsManager';

const TAG: string = 'OpenCloseActionLifeCycleStatusManager';
const log: Logger = Logger.getLogHelper(LogDomain.HOME);

/**
 * 打开关闭状态管理类
 */
export class OpenCloseActionLifeCycleStatusManager extends FolderActionLifeCycleStatusManager {
  private static sInstance: OpenCloseActionLifeCycleStatusManager;
  private mActionEventMgr: FolderActionLifeCycleEventManager = FolderActionLifeCycleEventManager.getInstance();

  static getInstance(): OpenCloseActionLifeCycleStatusManager {
    if (OpenCloseActionLifeCycleStatusManager.sInstance == null) {
      OpenCloseActionLifeCycleStatusManager.sInstance = new OpenCloseActionLifeCycleStatusManager();
    }
    return OpenCloseActionLifeCycleStatusManager.sInstance;
  }

  constructor() {
    super();
    this.now = FolderActionLifeCycleStatus.CLOSED;
    /* 不添加的就是不允许跳转的状态 */
    /* 操作：打开文件夹 */
    this.transitions.push(
      new FolderActionTransition().from(FolderActionLifeCycleStatus.CLOSED).to(FolderActionLifeCycleStatus.OPENING));
    this.transitions.push(
      new FolderActionTransition().from(FolderActionLifeCycleStatus.OPENING).to(FolderActionLifeCycleStatus.OPENED));

    /* 操作：关闭文件夹 */
    this.transitions.push(
      new FolderActionTransition().from(FolderActionLifeCycleStatus.OPENED).to(FolderActionLifeCycleStatus.CLOSING));
    this.transitions.push(
      new FolderActionTransition().from(FolderActionLifeCycleStatus.CLOSING).to(FolderActionLifeCycleStatus.CLOSED));

    /* 操作：打开关闭文件夹的打断场景 */
    this.transitions.push(
      new FolderActionTransition().from(FolderActionLifeCycleStatus.OPENING).to(FolderActionLifeCycleStatus.CLOSING));
    this.transitions.push(
      new FolderActionTransition().from(FolderActionLifeCycleStatus.CLOSING).to(FolderActionLifeCycleStatus.OPENING));

    /* 操作：无动效立刻打开关闭文件夹场景 */
    this.transitions.push(
      new FolderActionTransition().from(FolderActionLifeCycleStatus.CLOSED).to(FolderActionLifeCycleStatus.OPENED));
    this.transitions.push(
      new FolderActionTransition().from(FolderActionLifeCycleStatus.OPENED).to(FolderActionLifeCycleStatus.CLOSED));

    /* 操作: 打开文件夹过程中立刻无动效关闭文件夹场景，如：打开文件夹过程中立刻折叠或展开手机或锁屏 */
    this.transitions.push(
      new FolderActionTransition().from(FolderActionLifeCycleStatus.OPENING).to(FolderActionLifeCycleStatus.CLOSED));
  }

  /**
   * 文件夹打开动效完成。此接口是内部细化打开过程生命周期的子接口，仅在打开动效的指定场景调用，调用后表明打开动效完成。
   *
   *     此接口只能由最后的动效类调用。即opening的生命周期，和动效保持一致。但是这样会导致业务在此过程中执行的一些数据处理，特别是异步的，
   * 会需要业务自行打断，但是这些过程中，应该是基本没有数据处理的。
   *     考虑几种场景：
   * 1. 拖拽可能会涉及数据的刷新。但是这个刷新应该设计上被动效遮住。这种是不应该被打断的
   * 2. 打开的过程中，一个图标从下载中切换到下载完成状态，这里也涉及数据库的刷新，也是不应该被打断的
   *     综上看，目前并没有需要支持打断的异步的操作。
   *     再继续看待这个问题，假如确实需要支持拖拽落位过程中，可被其他状态打断，那么，仅需要此函数提供一个callback接口，
   * 接口注册到拖拽->另一状态的when回调上，然后就可以由业务在callback里判断数据刷新是否完成，如果完成就可以直接打断。
   * 这样同时不会影响其他的状态变化。
   *
   * @param msg 操作标记，用于DFX维测
   */
  public opened(msg: string): void {
    const openFolder: GridLayoutItemInfo = FolderManager.getInstance().getOpenedFolder();
    if (!openFolder) {
      log.showWarn(TAG, 'opened dir failed, no opening folder ?');
      return;
    }
    // desktopUtil.setApsSceneWindowCheck(apsManager.SceneAnimation.OPEN_FOLDER, 0);
    log.showInfo(TAG, 'folder opened, by (%{public}s)', msg);
    this.tryAction(FolderActionLifeCycleStatus.OPENED, null, (from, to) => {
      this.mActionEventMgr.notify(msg, openFolder, FolderActionLifeCycleStatus.OPENED);
    });
  }

  /**
   * 文件夹关闭动效完成。此接口是内部细化打开过程生命周期的子接口，仅在关闭动效的指定场景调用，调用后表明关闭动效完成。
   *
   * @param msg 操作标记，用于DFX维测
   */
  public closed(msg: string): void {
    const closingFolder: GridLayoutItemInfo = FolderManager.getInstance().getClosingFolder();
    if (!closingFolder) {
      let err = '';
      if (FolderManager.getInstance().getOpenedFolder()) {
        err = 'clear opened-folder';
      }
      log.showWarn(TAG, 'closed folder by(%{public}s) failed, no opening folder ... %{public}s', msg, err);
      return;
    }
    // desktopUtil.setApsSceneWindowCheck(apsManager.SceneAnimation.OPEN_FOLDER, 0);
    // desktopUtil.setApsSceneWindowCheck(apsManager.SceneAnimation.CLOSE_FOLDER, 0);
    log.showInfo(TAG, 'folder closed, by (%{public}s)', msg);
    this.tryAction(FolderActionLifeCycleStatus.CLOSED, null, (from, to) => {
      this.mActionEventMgr.notify(msg, closingFolder, FolderActionLifeCycleStatus.CLOSED);
      FolderManager.getInstance().setClosingFolder(undefined);
    });
  }

  /**
   * 切换到打开的状态
   *
   * @param msg 用于DFX日志打印
   * @param folder 文件夹
   */
  public toOpened(msg: string, folder: GridLayoutItemInfo): void {
    this.tryAction(FolderActionLifeCycleStatus.OPENED,
      /* 优先标记，避免业务在callback回调中调用data接口无法获取准确状态 */
      (from, to) => {
        FolderManager.getInstance().setOpenedFolder(folder);
        FolderManager.getInstance().setClosingFolder(undefined);
      },
      /* 再通知上层业务 */
      (from, to) => {
        this.mActionEventMgr.notify(msg, folder, FolderActionLifeCycleStatus.OPENED);
      }
    );
  }

  /**
   * 切换到打开中的状态
   *
   * @param msg 用于DFX日志打印
   * @param folder 文件夹
   */
  public toOpening(msg: string, folder: GridLayoutItemInfo): void {
    this.tryAction(FolderActionLifeCycleStatus.OPENING,
      /* 优先标记，避免业务在callback回调中调用data接口无法获取准确状态 */
      (from, to) => {
        FolderManager.getInstance().setOpenedFolder(folder);
        FolderManager.getInstance().setClosingFolder(undefined);
        // desktopUtil.setApsSceneWindowCheck(apsManager.SceneAnimation.OPEN_FOLDER, 1);
        // desktopUtil.setApsSceneWindowCheck(apsManager.SceneAnimation.CLOSE_FOLDER, 0);
      },
      /* 再通知上层业务 */
      (from, to) => {
        this.mActionEventMgr.notify(msg, folder, FolderActionLifeCycleStatus.OPENING);
      }
    );
  }

  /**
   * 切换到关闭中的状态
   *
   * @param msg 用于DFX的日志打印
   * @param folder 关闭的文件夹
   */
  public toClosing(msg: string, folder: GridLayoutItemInfo): void {
    this.tryAction(FolderActionLifeCycleStatus.CLOSING,
      /* 优先标记，避免业务在callback回调中调用data接口无法获取准确状态 */
      (from, to) => {
        /*
         * 释放openedFolder，这样isFolderOpen返回结果正确。但是又希望callback回调能够获取当前文件夹的信息，
         * 所以新增了一个不对外开放的变量
         */
        FolderManager.getInstance().setClosingFolder(folder);
        FolderManager.getInstance().setOpenedFolder(undefined);
        // desktopUtil.setApsSceneWindowCheck(apsManager.SceneAnimation.CLOSE_FOLDER, 1);
        // desktopUtil.setApsSceneWindowCheck(apsManager.SceneAnimation.OPEN_FOLDER, 0);
      },
      /* 再通知上层业务 */
      (from, to) => {
        if (!FolderManager.getInstance().getClosingFolder()) {
          log.showWarn(TAG, 'null closing folder ?');
          return;
        }
        this.mActionEventMgr.notify(msg, folder, FolderActionLifeCycleStatus.CLOSING);
      }
    );
  }

  /**
   * 切换到已关闭的状态
   *
   * @param msg 用于DFX的日志打印
   * @param folder 关闭的文件夹
   */
  public toClosed(msg: string, folder: GridLayoutItemInfo): void {
    this.tryAction(FolderActionLifeCycleStatus.CLOSED,
      /* 优先标记，避免业务在callback回调中调用data接口无法获取准确状态 */
      (from, to) => {
        /*
         * 释放openedFolder，这样isFolderOpen返回结果正确。但是又希望callback回调能够获取当前文件夹的信息，
         * 所以新增了一个不对外开放的变量
         */
        FolderManager.getInstance().setClosingFolder(folder);
        FolderManager.getInstance().setOpenedFolder(undefined);
      },
      /* 再通知上层业务 */
      (from, to) => {
        if (!FolderManager.getInstance().getClosingFolder()) {
          log.showWarn(TAG, 'null closing folder ?');
          return;
        }
        this.mActionEventMgr.notify(msg, folder, FolderActionLifeCycleStatus.CLOSED);
        FolderManager.getInstance().setClosingFolder(undefined);
        FolderManager.getInstance().setOpenFolderId('-1');
      },
    );
  }

  /**
   * 立即关闭文件夹
   *
   * @param msg 用于DFX日志
   * @param folder 文件夹
   */
  public toClosedRepair(msg: string, folder: GridLayoutItemInfo): void {
    this.tryAction(FolderActionLifeCycleStatus.CLOSED,
      /* 优先标记，避免业务在callback回调中调用data接口无法获取准确状态 */
      (from, to) => {
        /* 不同于closedImmediately，这里不能覆盖closingFolder，否则就被清空了，导致notifyFolderClosed无法进行 */
        FolderManager.getInstance().setOpenedFolder(undefined);
      },
      /* 再通知上层业务 */
      (from, to) => {
        if (!FolderManager.getInstance().getClosingFolder()) {
          log.showWarn(TAG, 'null closing folder ?');
          return;
        }
        this.mActionEventMgr.notify(msg, folder, FolderActionLifeCycleStatus.CLOSED);
        FolderManager.getInstance().setClosingFolder(undefined);
        FolderManager.getInstance().setOpenFolderId('-1');
      }
    );
  }
}