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
 * 合并对象
 * @param source
 * @returns
 */
export function combineObject(...source: Object[]): Record<string, Object> {
  let result: Record<string, Object> = {};
  for (const items of source) {
    for (const key of Object.keys(items)) {
      result[key] = Reflect.get(items, key);
    }
  }
  return result;
}

/**
 * 防抖函数
 * @param fn
 * @param delay
 * @returns
 */
export function debounce<T extends (...args: Object[]) => void>(fn: T, delay: number): T {
  let timerId: number | undefined;
  const newFn = (...args: Object[]): void => {
    if (timerId !== undefined) {
      clearTimeout(timerId);
    }
    timerId = setTimeout(() => {
      timerId = undefined;
      fn(...args);
    }, delay);
  };
  return newFn as T;
}

/**
 * 节流函数
 * @param fn
 * @param delay
 * @returns
 */
export function throttle<T extends (...args: Object[]) => void>(fn: T, delay: number): T {
  let inThrottle: boolean = false;
  const newFn = (...args: Object[]): void => {
    if (inThrottle) {
      return;
    }
    inThrottle = true;
    fn(...args);
    setTimeout(() => {
      inThrottle = false;
    }, delay);
  };
  return newFn as T;
}