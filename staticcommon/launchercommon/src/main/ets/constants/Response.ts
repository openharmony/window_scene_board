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

/**
 * 响应消息
 */
export class Response {
  /**
   * 成功反馈
   */
  public static readonly SUCCESS = 'success';

  /**
   * 失败反馈
   */
  public static readonly FAIL = 'fail';

  public static readonly SUCCESS_OK = 'OK';

  public static readonly INVALID_METHOD_ERROR = 'invalid method';

  public static readonly UNKNOWN_METHOD_ERROR = 'unknown method';
}