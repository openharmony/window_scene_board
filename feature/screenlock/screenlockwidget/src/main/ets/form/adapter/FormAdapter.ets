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
import { BaseAdapter, IAdapter } from '../../common/adapter/BaseAdapter';
import { UseScene } from '../../common/adapter/Constans';
import { DataManager } from '../../common/adapter/DataManager';

/**
 * 适配器类，用于适配外部接入组件
 */
class FormAdapter extends BaseAdapter {
  getDataManager(): DataManager {
    return new DataManager();
  }

}

/**
 * 锁屏卡片组件适配器工厂类
 *
 */
export class FormAdapterFactory {
  /**
   * 获取适配器实例
   *
   * @returns 适配器
   */
  static wrapper(): IAdapter {
    return new FormAdapter(UseScene.DEFAULT_SCENE);
  };
}