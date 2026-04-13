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
import { RemoteCode } from './RemoteCode';

/**
 * RemoteRsp类，用于处理远程响应
 */
export class RemoteRsp {
  /**
   * 成功
   */
  public static readonly SUCCESS = new RemoteRsp(RemoteCode.SUCCESS, 'SUCCESS');

  /**
   * 未知错误响应
   */
  public static readonly ERR_UNKNOWN = new RemoteRsp(RemoteCode.ERR_UNKNOWN, 'Unknown error');

  /**
   * 接口不存在响应
   */
  public static readonly ERR_API_NOT_EXIST = new RemoteRsp(RemoteCode.ERR_UNIMPL, 'Unsupported API');

  /**
   * 调用者不合法响应
   */
  public static readonly ERR_ILLEGAL_CALLER =
    new RemoteRsp(RemoteCode.ERR_ILLEGAL_CALLER, 'Client authentication failed');

  /**
   * IDL内部错误响应
   */
  public static readonly ERR_INNER_IDL = new RemoteRsp(RemoteCode.ERR_INNER_IDL, 'Inner error occurred');

  /**
   * 请求参数错误
   */
  public static readonly ERR_PARAM = new RemoteRsp(RemoteCode.ERR_PARAM, 'Param error');

  /**
   * OHOS系统错误
   */
  public static readonly ERR_OHOS_ERROR =
    new RemoteRsp(RemoteCode.ERR_OHOS_ERROR, 'Failed to invoke the OHOS system API.');

  /**
   * 结果码
   */
  public code: number;

  /**
   * 描述
   */
  public desc: string;

  /**
   * 业务响应数据
   */
  public value?: string;

  constructor(code: number, desc: string, value?: string) {
    this.code = code;
    this.desc = desc;
    this.value = value;
  }
}

