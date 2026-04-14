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
import {
  ParserController
} from '@ohos/systemuicommon';
import type {
  IParser
} from '@ohos/systemuicommon';
import {
  ParseResultType
} from '@ohos/systemuicommon';
import type { BaseNotification } from '@ohos/systemuicommon';
import type { ImmersiveNtfData } from '../../viewmodel/viewdata/ImmersiveNtfData';
import { immersiveNtfAdapter } from './ImmersiveNtfAdapter';

const TAG = 'ImmersiveNtfDataParser';

/**
 * 沉浸实况数据解析器
 */
class ImmersiveNtfDataParser implements IParser<BaseNotification, ImmersiveNtfData> {
  /**
   * 复写IParser
   *
   * @param oriData 原数据
   * @param result 上层结果数据
   * @returns 此次结果数据
   */
  parse(oriData: BaseNotification, result?: ImmersiveNtfData): ImmersiveNtfData | undefined {
    result = immersiveNtfAdapter.parse(oriData);
    // 数据解析完成
    if (result) {
      result.resultType = ParseResultType.MATCH;
    }
    return result;
  }
}

/**
 * 沉浸实况数据解析器管理
 */
export class ImmersiveNtfDataParserController extends ParserController<BaseNotification, ImmersiveNtfData> {
  constructor() {
    super(TAG);
    // 添加数据解析器
    this.addParser(new ImmersiveNtfDataParser());
  }
}