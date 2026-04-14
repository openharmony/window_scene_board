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

import lazy ArrayList from '@ohos.util.ArrayList';
import lazy { GlobalContext } from '../utils/GlobalContext';
import { Constants } from './Constants';
import { Log } from './Log';

const TAG: string = 'PathReloadStrategy';

/**
 * 主题引擎资源路径更新
 *
 * @since 2024-05-15
 */
export class PathReloadStrategy {
  // 需要更新资源路径listener的合集
  public listenerList: ArrayList<RootPathChangeListener> = new ArrayList<RootPathChangeListener>();

  private static instance: PathReloadStrategy;

  /**
   * HandleUpdatePathEvent 单例
   *
   * @returns HandleUpdatePathEvent 单例
   */
  public static getInstance(): PathReloadStrategy {
    if (!PathReloadStrategy.instance) {
      PathReloadStrategy.instance = new PathReloadStrategy();
    }
    return PathReloadStrategy.instance;
  }

  /**
   * 通知所有需要更新资源路径的listener
   *
   * @param rootPath 当前最新A/B目录
   */
  public updateRootPath(rootPath: string): void {
    GlobalContext.getContext().setObject(Constants.SANDBOX, rootPath);
    AppStorage.setOrCreate<string>('activeThemePath', rootPath);
    this.listenerList.forEach((listener) => {
      listener.onRootPathChange();
    });
  }

  /**
   * 对需要资源更新的注册listener
   *
   * @param 需要资源路径更新的listener
   */
  public addUpdateRootPathListener(listener: RootPathChangeListener): void {
    this.listenerList.add(listener);
  }

  /**
   * 删除资源更新listener
   *
   * @param 需要删除的listener
   */
  public removeUpdateRootPathListener(listener: RootPathChangeListener): void {
    if (!this.listenerList.has(listener)) {
      return;
    }

    try {
      this.listenerList.remove(listener);
    } catch (err) {
      Log.error(TAG, `Error on removing reload listener ${err.code}`);
    }
  }
}

/**
 * 需要资源路径更新的一类listener
 *
 * @since 2024-05-18
 */
export interface RootPathChangeListener {
  onRootPathChange: () => void;
}