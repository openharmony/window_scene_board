/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

export namespace ThemeCode {
  /**
   * 成功
   */
  export const SUCCESS: number = 0;

  /**
   * 未知错误
   */
  export const UNKNOWN_ERROR: number = -1;

  /**
   * 参数错误
   */
  export const ERROR_PARAMS: number = 100000;

  /**
   * 文件copy失败
   */
  export const ERROR_COPY_FILE: number = 100001;

  /**
   * 不支持的服务
   */
  export const ERROR_UNSUPPORT_SERVICE: number = 100002;

  /**
   * 应用主题失败
   */
  export const ERROR_ACTIVATE_THEME: number = 100003;

  /**
   * 试用主题转会员主题/付费主题失败
   */
  export const ERROR_PROMOTE_TRIAL_THEME: number = 100004;

  /**
   * 回退主题失败
   */
  export const ERROR_ROLLBACK_THEME: number = 100005;

  /**
   * 校验id失败
   */
  export const ERROR_NOT_MATCHED_ID: number = 100006;
}
