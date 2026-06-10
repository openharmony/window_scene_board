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
import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';

import { MultiSelectItemType, type MultiSelectListenerType } from '../data/MultiSelectData';
import { Position } from '@ohos.arkui.node';
import { GridLayoutItemInfo, GridLayoutUtil } from '../../TsIndex';

const TAG: string = 'MultiSelectListenerManage';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 编辑模式多选事件监听类 禁止私自调用execute方法
 */
export class MultiSelectListenManager {
  private readonly listenerMap: Map<string, MultiSelectListenerType> = new Map();

  /**
   * 注册监听者
   * @param listener
   */
  public register(listener: MultiSelectListenerType): void {
    if (this.listenerMap.has(listener.id)) {
      log.showError(`listener regist repeat ${listener.id}`);
    }
    this.listenerMap.set(listener.id, listener);
  }

  /**
   * 取消注册监听者
   * @param listener
   */
  public unregister(listener?: MultiSelectListenerType): void {
    if (listener) {
      let events = this.listenerMap.get(listener.id);
      if (events && events === listener) {
        this.listenerMap.delete(listener.id);
      } else {
        log.showError(`unregister error: ${listener.id}`);
      }
    }
  }

  /**
   * 清空
   */
  public clearAll() : void {
    this.listenerMap.clear();
  }

  /**
   * 触发进入多选事件
   */
  public executeEnter(): void {
    log.showInfo('listener execute executeEnter');
    this.listenerMap.forEach(listener => {
      listener.onEnter?.();
    });
  }

  /**
   * 触发退出多选事件
   */
  public executeExit(): void {
    log.showInfo('listener execute executeExit');
    this.listenerMap.forEach(listener => {
      listener.onExit?.();
    });
  }

  /**
   * 触发选中元素变化事件
   */
  public executeUpdatingMultiSelectMap(listenerIds: string[] = []): void {
    log.showInfo('listener executeUpdatingMultiSelectMap');
    if (listenerIds.length === 0) {
      this.listenerMap.forEach(listener => {
        listener.onUpdatingMultiSelectMap?.();
      });
    } else {
      listenerIds.forEach(id => {
        const listener: MultiSelectListenerType | undefined = this.listenerMap.get(id);
        listener?.onUpdatingMultiSelectMap?.();
      });
    }
  }

  /** 触发长按效果事件 定点发送 */
  public executeLongPress(listenerIds: string[] = []): void {
    log.showInfo('listener execute executeLongPress');
    this.sendEvent(listenerIds, listener => listener.onLongPress?.(), true);
  }

  /** 触发汇聚过程中拖拽移动事件 定点发送 */
  public executeMoveWhenGathering(listenerIds: string[] = [], touchPos: Position): void {
    log.showInfo('listener execute executeMoveWhenGathering');
    this.sendEvent(listenerIds, listener => listener.onMoveWhenGathering?.(touchPos));
  }

  /** 触发汇聚过程中落位事件 定点发送 */
  public executeDropWhenGathering(listenerIds: string[] = []): void {
    log.showInfo('listener execute executeDropWhenGathering');
    this.sendEvent(listenerIds, listener => listener.onDropWhenGathering?.());
  }

  /** 触发预拖动事件 */
  public executeBeforeGather(listenerIds: string[] = []): void {
    log.showInfo('listener execute executeBeforeGather');
    this.sendEvent(listenerIds, listener => listener.beforeGather?.());
  }

  /**
   * 触发汇聚事件
   */
  public async executeGather(): Promise<void> {
    log.showInfo('listener execute executeGather');
    this.listenerMap.forEach(async listener => {
      listener.onGather?.();
    });
  }

  /**
   * 触发开始拖动事件
   */
  public executeDragging(): void {
    log.showInfo('listener execute executeDragging');
    this.listenerMap.forEach(listener => {
      listener.onDragging?.();
    });
  }

  /**
   * 触发开始落位事件
   */
  public executeDropping(listenerIds: string[] = []): void {
    log.showInfo('listener execute executeDropping');
    this.sendEvent(listenerIds, listener => listener.onDropping?.());
  }

  /** 触发应用落位完成回调 */
  public executeItemDropped(listenerIds: string[] = []): void {
    log.showInfo('listener executeItemDropped');
    this.sendEvent(listenerIds, listener => listener.onItemDropped?.());
  }

  /**
   * 触发应用完成拖拽后显示名称回调
   */
  public executeShowAppName(listenerIds: string[] = []): void {
    log.showInfo('listener executeShowAppName');
    this.sendEvent(listenerIds, listener => listener.onShowAppName?.());
  }

  /**
   * 触发拖拽完成事件
   */
  public executeFinish(): void {
    log.showInfo('listener executeFinish');
    this.listenerMap.forEach(listener => {
      try {
        listener.onFinish?.();
      } catch (e) {
        log.showError(`executeFinish error, listenerId: ${listener.id}`);
      }
    });
  }

  /**
   * 触发UpdateItemInfo事件 通知checkbox更新自身属性
   */
  public executeUpdateState(listenerIds: string[] = []): void {
    log.showInfo('listener executeUpdateItemInfo');
    if (listenerIds.length === 0) {
      this.listenerMap.forEach(listener => {
        listener.onUpdateState?.();
      });
    } else {
      listenerIds.forEach(id => {
        const listener: MultiSelectListenerType | undefined = this.listenerMap.get(id);
        listener?.onUpdateState?.();
      });
    }
  }

  public executeCustomDrop(listenerIds: string[] = [], touchPos: Position): void {
    log.showInfo('listener executeCustomDrop');
    this.sendEvent(listenerIds, listener => listener.onCustomDrop?.(touchPos));
  }

  public executeGatherMove(listenerIds: string[] = [], touchPos: Position): void {
  log.showInfo('listener executeGatherMove');
  this.sendEvent(listenerIds, listener => listener.onCustomDrop?.(touchPos));
}

  private sendEvent(
    ids: string[],
    callback: (listener: MultiSelectListenerType) => void,
    isAsync: boolean = false
  ): void {
    this.listenerMap.forEach(listener => {
      if (ids.length === 0 || ids.includes(listener.id)) {
        isAsync ? new Promise<void>((resolve) => {
          callback(listener);
          resolve();
        }) : callback(listener);
      }
    });
  }

  /**
   * 获取multiSelectListenManager的唯一标识符id
   */
  public getListenerId(type: ListenerItemType, id: string, isOuterDesktop: boolean = false): string {
    return isOuterDesktop ? `${type}_${id}_OuterDesktop` : `${type}_${id}`;
	}
}

/*
 * 注册监听器的对象类型
 */
export enum ListenerItemType {
  BIG_FOLDER = 'bigFolderItem',
  SMALL_FOLDER = 'smallFolderItem',
  DESKTOP_ITEM = 'desktopItem',
  SWIPER_ITEM = 'swiperItem',
  OPEN_FOLDER_SWIPER_ITEM = 'openFolderSwiperItem',
  APP_ICON = 'app',
  OPENFOLDER_APP = 'openFolderApp',
  MULTISELECT_CHECKBOX_VIEW = 'checkBox',
  GRID_SWIPER = 'gridSwiper',
  FOLDER_VIEW_MODEL = 'folderViewModel',
  MULTISELECT_ANIMATE_MANAGER = 'multiSelectAnimateManager',
  MULTISELECT_CHECKBOX_MANAGER = 'MultiSelectCheckboxManager',
  EDIT_MODE_TOP_BAR = 'editModeTopBar',
}

export const multiSelectListenManager: MultiSelectListenManager = SingletonHelper.getInstance(MultiSelectListenManager, TAG);