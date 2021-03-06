/*
 * Copyright 2020 The Backstage Authors
 *
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
import {
  createExternalRouteRef,
  createRouteRef,
  createSubRouteRef,
} from '@backstage/core-plugin-api';

export const registerComponentRouteRef = createExternalRouteRef({
  id: 'register-component',
  optional: true,
});

export const rootRouteRef = createRouteRef({
  id: 'scaffolder',
});

export const selectedTemplateRouteRef = createSubRouteRef({
  id: 'scaffolder/selected-template',
  parent: rootRouteRef,
  path: '/templates/:templateName',
});

export const scaffolderTaskRouteRef = createSubRouteRef({
  id: 'scaffolder/task',
  parent: rootRouteRef,
  path: '/tasks/:taskId',
});

export const actionsRouteRef = createSubRouteRef({
  id: 'scaffolder/actions',
  parent: rootRouteRef,
  path: '/actions',
});

export const editRouteRef = createSubRouteRef({
  id: 'scaffolder/edit',
  parent: rootRouteRef,
  path: '/edit',
});
