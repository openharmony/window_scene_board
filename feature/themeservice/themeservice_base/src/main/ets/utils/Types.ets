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

import { common } from '@kit.AbilityKit';
import type ArrayList from '@ohos.util.ArrayList';
import type HashMap from '@ohos.util.HashMap';
import type LightWeightMap from '@ohos.util.LightWeightMap';
import type LinkedList from '@ohos.util.LinkedList';
import type List from '@ohos.util.List';
import type TreeMap from '@ohos.util.TreeMap';

/**
 * 映射类型：类构造函数
 */
export type ClassConstructor<T> = (...args: AnyType[]) => T;

/**
 * map类型
 */
export type MapType<K, V> = Map<K, V> | HashMap<K, V> | TreeMap<K, V> | LightWeightMap<K, V>;

/**
 * map类型
 */
export type MapTypes = MapType<AnyType, AnyType>;

/**
 * ohos定义的Map类型
 */
export type OhosMapTypes = HashMap<AnyType, AnyType> | TreeMap<AnyType, AnyType> | LightWeightMap<AnyType, AnyType>;

/**
 * array 类型
 */
export type ArrayType<T> = Array<T> | List<T> | ArrayList<T> | LinkedList<T>;

/**
 * set 类型
 */
export type SetType<T> = Set<T>;

/**
 * ohos定义的List类型
 */
export type OhosListTypes = List<AnyType> | ArrayList<AnyType> | LinkedList<AnyType>;

// 基本类型
export type PrimitiveType = string | boolean | number | bigint | null | undefined;

// 非基本类型
export type NonPrimitiveType = object;

// 任意类型
export type AnyType = PrimitiveType | NonPrimitiveType;

// 任意函数
export type AnyFunction = (...args: AnyType[]) => AnyType | void;

/**
 * 键值对
 */
export type Entry = Record<string, PrimitiveType>;

/**
 * 可空类型
 */
export type NullableType<T> = T | undefined | null;

export type Nullable<T> = T | undefined;

/**
 * Theme service context
 */
export type TsContext = common.UIAbilityContext | common.ServiceExtensionContext;