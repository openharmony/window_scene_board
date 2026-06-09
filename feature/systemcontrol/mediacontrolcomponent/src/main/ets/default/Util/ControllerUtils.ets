/*
 * Copyright (c) Huawei Device Co., Ltd. 2025. All rights reserved.
 */

export default class ControllerUtils {
  /**
   * 根据输入的key值自动获取映射出来的需要执行的函数合集
   *
   * @param keys 映射的key列表
   * @param methodsMap 映射大表格，里面的key包含入参的key
   * @returns 映射后需要执行的函数合集
   */
  public static getExecuteMethods(keys: Array<string>, methodsMap: Map<string, Array<Function>>): Set<Function> {
    let result: Set<Function> = new Set<Function>();
    keys.forEach(key => {
      let methods = methodsMap.get(key);
      if (methods !== undefined) {
        for (let method of methods) {
          result.add(method);
        }
      }
    });
    return result;
  }

}