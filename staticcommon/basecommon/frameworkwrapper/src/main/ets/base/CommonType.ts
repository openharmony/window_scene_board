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
 * 类类型
 */
export interface Class<T> {
  new(...args: Object[]): T;
}

/**
 * 去除never属性
 */
export type ExcludeNever<T> = Pick<T, { [K in keyof T]: T[K] extends never ? never : K }[keyof T]>;

/**
 * 获取对象中的方法
 */
export type FunctionOf<T> = ExcludeNever<{
  [K in keyof T]: T[K] extends Function ? T[K] : never;
}>;

/**
 * 去除方法
 */
export type ExcludeFunction<T> = ExcludeNever<{
  [K in keyof T]: T[K] extends Function ? never : T[K]
}>;

/**
 * 从结构中选出属性集合，排除方法
 */
export type Props<T> = {
  [K in keyof ExcludeFunction<T>]: ExcludeFunction<T>[K];
};

/**
 * 将所有字段设置为可为null
 */
export type Nullable<T> = {
  [K in keyof T]: T[K] | null;
};

/**
 * 取一个对象中某个字段的值类型
 */
export type ValueOf<T, K extends keyof T = keyof T> = T[K];

/**
 * 取一个对象的属性集合，并且所有字段都是可选
 */
export type PartialObjectOf<T> = {
  [K in keyof Props<T>]?: T[K];
};