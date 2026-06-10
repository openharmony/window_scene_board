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
import type { IResult } from './IResult';

/**
 * 解析器接口
 * <P>原数据
 * <T>结果数据
 */
export interface IParser<P, T extends IResult> {
  /**
   * 数据解析
   *
   * @param oriData 原数据
   * @param result 现有解析结果对象
   * @returns 解析结果
   */
  parse(oriData: P, result?: T): T | undefined;
}