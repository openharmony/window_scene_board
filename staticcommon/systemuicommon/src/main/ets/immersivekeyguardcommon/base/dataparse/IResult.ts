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

/**
 * 结果类型
 */
export enum ParseResultType {
  /**
   * 不匹配，直接继续解析链条
   */
  MISS = 0,

  /**
   * 参与解析，继续解析链条
   */
  JOIN,

  /**
   * 已匹配，终止解析链条
   */
  MATCH
}

/**
 * 解析结果接口
 */
export interface IResult {
  /**
   * 结果类型
   */
  resultType: ParseResultType;
}