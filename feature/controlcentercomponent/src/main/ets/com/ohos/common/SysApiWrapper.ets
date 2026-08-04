/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

export class SysApiWrapper {
  /**
   * animateTo的代理，用于DT测试时替换animateTo的实现，解决animateTo无法测试问题
   */
  public static animateTo = (value: AnimateParam, event: () => void): void => {
    animateTo(value, event);
  }
  /**
   * setTimeout的代理，用于DT测试时替换setTimeout的实现，解决setTimeout异步执行导致用例失败问题
   */
  public static setTimeout = (handler: Function | string, delay?: number): number => {
    return setTimeout(handler, delay);
  }
}