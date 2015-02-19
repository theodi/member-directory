Chargify integration
===========================

Product setup
-------------

For each pricing plan available for supporters there needs to be a product
setup in Chargify that maps to it by setting the `API Handle`.

Currently the system expects there to be products for

  1. `individual_supporter`
  2. `supporter_annual`
  3. `corporate_supporter_annual`

You can then set up the `Recurring Period and Price` for each of these
products. `Initial/Setup Fee` can be left blank as Chargify starts billing
immediately for the recurring payment.

Everytime you create a product you need to set up a `Public Signup Page` for
the product with the `Return url` and `Return parameters` set to these values:

### Return url

    https://directory.theodi.org/members/chargify_return

### Return parameters

    reference={customer_reference}&customer_id={customer_id}&subscription_id={subscription_id}&payment_id={signup_payment_id}


Deployment setup
================

## Environment variables

### `CHARGIFY_API_KEY`

The API key from Chargify, available from the `API Access` menu.

### `CHARGIFY_SUBDOMAIN`

The subdomain name of the `Site` created in Chargify

### `CHARGIFY_SITE_KEY`

Available at the bottom of the edit page for the `Site`
