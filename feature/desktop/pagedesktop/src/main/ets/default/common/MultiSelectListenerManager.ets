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
import { MultiSelectListenerType } from '@ohos/launchercommon';
import { PageDesktopViewModel } from './viewmodel/PageDesktopViewModel';

const TAG: string = 'multiSelectListenerManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * PC多选事件监听类 禁止私自调用execute方法
 */
export class MultiSelectListenerManager {
  private readonly listenerMap: Map<string, MultiSelectListenerType> = new Map();

  /**
   * 注册监听者
   * @param listener
   */
  public register(listener: MultiSelectListenerType): void {
    log.showInfo(`listener regist ${listener.id}`);
    if (this.listenerMap.has(listener.id)) {
      log.showError(`listener regist repeat ${listener.id}`);
    }
    this.listenerMap.set(listener.id, listener);
  }

  /**
   * 取消注册监听者
   * @param listener
   */
  public unregister(listener: MultiSelectListenerType): void {
    let events = this.listenerMap.get(listener.id);
    log.showInfo('listener unregister %{public}s', listener.id);
    if (events && events === listener) {
      this.listenerMap.delete(listener.id);
    }
  }

  /**
   * 清空
   */
  public clearAll() : void {
    this.listenerMap.clear();
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
   * 触发拖拽完成事件
   */
  public executeFinish(): void {
    log.showInfo('listener executeFinish');
    this.listenerMap.forEach(listener => {
      listener.onFinish?.();
    });
    PageDesktopViewModel.getInstance().setMultiDragStart(false, TAG);
  }

}

export const multiSelectListenerManger: MultiSelectListenerManager =
  SingletonHelper.getInstance(MultiSelectListenerManager, TAG);

