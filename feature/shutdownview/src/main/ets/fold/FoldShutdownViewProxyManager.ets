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
import { SCBSessionRect } from '@ohos/windowscene';
import { SCBFoldState } from '../utils/Constants';
import { FoldShutdownViewProxy } from './FoldShutdownViewProxy'

export class FoldShutdownViewProxyManager {
  private static instance: FoldShutdownViewProxyManager;
  private foldShutDownViewProxyImpl: FoldShutdownViewProxy | null = null;

  private constructor() {
  }

  public static getInstance(): FoldShutdownViewProxyManager {
    if (!FoldShutdownViewProxyManager.instance) {
      FoldShutdownViewProxyManager.instance = new FoldShutdownViewProxyManager();
    }
    return FoldShutdownViewProxyManager.instance;
  }

  public setFoldShutdownViewProxyImpl(proxy: FoldShutdownViewProxy) {
    this.foldShutDownViewProxyImpl = proxy;
  }

  /**
   * 获取当前折叠屏状态
   *
   * @param screenId 屏幕id
   * @returns 折叠屏状态
   */
  public getCurBigScreenStatus(screenId?: number): SCBFoldState {
    if (this.foldShutDownViewProxyImpl === null) {
      return SCBFoldState.UNKNOWN;
    }
    return this.foldShutDownViewProxyImpl.getCurBigScreenStatus(screenId);
  }

  /**
   * 获取B面区域
   *
   * @returns B面区域信息
   */
  public getBSideRegion(): SCBSessionRect {
    if (this.foldShutDownViewProxyImpl === null) {
      return new SCBSessionRect(0, 0, 0, 0);
    }
    return this.foldShutDownViewProxyImpl.getBSideRegion();
  }

  public registerFoldSceneStateChangeCallback(callback: Function, isPriority: boolean = false, tag?: string): void {
    if (this.foldShutDownViewProxyImpl === null) {
      return;
    }
    this.foldShutDownViewProxyImpl.registerFoldSceneStateChangeCallback(callback, isPriority, tag);
  }

  public unregisterFoldSceneStateChangeCallback(callback: Function, tag?: string): void {
    if (this.foldShutDownViewProxyImpl === null) {
      return;
    }
    this.foldShutDownViewProxyImpl.unregisterFoldSceneStateChangeCallback(callback, tag);
  }
}