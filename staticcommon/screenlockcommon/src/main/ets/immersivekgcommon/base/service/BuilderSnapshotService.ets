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
import { image } from '@kit.ImageKit';
import { ComponentSnapshot, UIContext } from '@ohos.arkui.UIContext';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { IBuilderSnapshot } from '../interface/IBuilderSnapshot';
import { BusinessError } from '@kit.BasicServicesKit';

const TAG = 'BuilderSnapshotService';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 离屏渲染组件截图服务
 */
export abstract class BuilderSnapshotService<T> implements IBuilderSnapshot<T> {
  // 组件截图工具
  private cmpSnapshot?: ComponentSnapshot;

  /**
   * 设置截图环境
   *
   * @param uiCtx 环境
   */
  public setUiContext(uiCtx?: UIContext): void {
    if (uiCtx) {
      this.cmpSnapshot = uiCtx.getComponentSnapshot();
    } else {
      this.cmpSnapshot = undefined;
    }
  }

  /**
   * 构造离屏组件
   *
   * @param param 参数
   * @returns 离屏组件
   */
  public abstract createBuilder(param: T): CustomBuilder;

  /**
   * 开启截图
   *
   * @param param 截图参数
   * @returns 截图结果
   */
  public async snapshot(param: T): Promise<image.PixelMap | undefined> {
    try {
      return this.cmpSnapshot?.createFromBuilder(() => this.createBuilder(param), 0, false,
        { waitUntilRenderFinished: true });
    } catch (e) {
      log.showError(`snapshot err: ${(e as BusinessError)?.code}`);
      return undefined;
    }
  }
}