/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */

import display from '@ohos.display';

const FOLD_STATE_EXPAND_WITH_SECOND_EXPAND: number = 11;

/**
 * 设备相关工具类
 *
 * @since 2025-03-19
 */
export class DeviceUtil {
  /**
   * 获取真实的设备状态
   *
   * @param status 设备状态
   * @returns 真实的设备状态
   */
  public static getActualFoldStatus(status: display.FoldStatus): display.FoldStatus {
    // 双折叠半折和M态半折更新为展开态
    if (status === display.FoldStatus.FOLD_STATUS_HALF_FOLDED) {
      return display.FoldStatus.FOLD_STATUS_EXPANDED;
    }

    // 22表示折叠和半折，12表示N态，更新为折叠态
    if (status === 22 || status === 12) {
      return display.FoldStatus.FOLD_STATUS_FOLDED;
    }

    // 13表示半折和展开 23表示半折和半折，21表示展开和半折，更新为G态
    if (status === 13 || status === 23 || status === 21) {
      return FOLD_STATE_EXPAND_WITH_SECOND_EXPAND;
    }

    // 展开态、G态
    return status;
  }
}