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
import { SingletonHelper } from '@ohos/basicutils';
import type { IResult } from './IResult';
import type { ParserController } from './ParserController';
import type { ParserControllerType } from './ParserControllerType';

const TAG = 'ParserControllerManager';

/**
 * 数据解析控制器统一管理
 */
class ParserControllerManager {
  /**
   * 数据解析控制器集合
   */
  private ctrlMap: Map<ParserControllerType, object> = new Map();

  /**
   * 添加数据解析控制器
   *
   * @param type 控制器类型
   * @param ctrl 控制器
   */
  addParserController<P, T extends IResult>(type: ParserControllerType, ctrl: ParserController<P, T>): void {
    this.ctrlMap.set(type, ctrl);
  }

  /**
   * 移除数据解析控制器
   *
   * @param type 控制器类型
   */
  removeParserController(type: ParserControllerType): void {
    this.ctrlMap.delete(type);
  }

  /**
   * 获取数据解析控制器
   *
   * @param type 控制器类型
   * @returns 解析器
   */
  getParserController<P, T extends IResult>(type: ParserControllerType): ParserController<P, T> | undefined {
    return this.ctrlMap.get(type) as ParserController<P, T>;
  }
}

// 单例
export let parserCtrlMgr: ParserControllerManager = SingletonHelper.getInstance(ParserControllerManager, TAG);