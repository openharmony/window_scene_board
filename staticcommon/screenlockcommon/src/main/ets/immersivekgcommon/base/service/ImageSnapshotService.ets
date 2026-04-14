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
import { image } from '@kit.ImageKit';
import { IImageSnapshot } from '../interface/IImageSnapshot';
import { BuilderSnapshotService } from './BuilderSnapshotService';

/**
 * 离屏渲染Image组件截图服务
 */
export class ImageSnapshotService extends BuilderSnapshotService<image.PixelMap> implements IImageSnapshot {
  // 离屏组件构造
  private _createBuilder: (param: image.PixelMap) => CustomBuilder;

  constructor(createBuilder: (param: image.PixelMap) => CustomBuilder) {
    super();
    this._createBuilder = createBuilder;
  }

  public createBuilder(param: image.PixelMap): CustomBuilder {
    return this._createBuilder?.(param);
  }
}